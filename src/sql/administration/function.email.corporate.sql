

DROP FUNCTION py_pgmail(text,text[], text[], text[],  text, text, text, text);

CREATE OR REPLACE FUNCTION public.py_pgmail(from_addr text, to_addr_list text[], cc_addr_list text[], bcc_addr_list text[], subject text, message_text text default '', message_html text default '', smtpserver text default '0.0.0.0') 
	RETURNS boolean
AS $$ 
	import smtplib
	from email.mime.multipart import MIMEMultipart
	from email.mime.text import MIMEText
	msg = MIMEMultipart('alternative')
	msg["Subject"] = subject
	msg['From'] = from_addr
	if len(to_addr_list)!=0:
		msg['To'] = ', '.join(to_addr_list)
	if len(cc_addr_list)!=0:
		msg['Cc'] = ', '.join(cc_addr_list)
	if message_text.replace(' ', '')!='':
		part1 = MIMEText(message_text, 'plain')
		msg.attach(part1)
	if message_html.replace(' ', '')!='':
		part2 = MIMEText(message_html, 'html')
		msg.attach(part2)
	if message_html.replace(' ', '')=='' and message_text.replace(' ', '')=='':
		plpy.info('An error ocurred: No message to send.')
		return False
	all_addr_list = to_addr_list+ cc_addr_list + bcc_addr_list
	all_addr_list = [i for i in all_addr_list if i not in ''] 
	server = smtplib.SMTP(smtpserver)
	problems = server.sendmail(from_addr, all_addr_list,msg.as_string())
	server.quit()
	if len(problems)>0:
		plpy.info('An error ocurred: '+str(problems))
		return False
	else:
		return True
$$ LANGUAGE plpython3u;



select py_pgmail(
	'alexandr.besan@corporatemail.ua',
	array['alexandr.besan@corporatemail.ua' ],
	array[ ''],
	array[ ''],
	'Test notification After', 
	'Text message! This is an email sent from a database!',
	'<!DOCTYPE html>
		<html>
		<body>
		<p>html message! This is an email sent from a database!</p>
		<table>
		  <tr>
		    <th>Month</th>
		    <th>Savings</th>
		  </tr>
		  <tr>
		    <td>January</td>
		    <td>$100</td>
		  </tr>
		</table>
		</body>
		</html>'
	);
