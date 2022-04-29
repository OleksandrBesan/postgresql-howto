

create view pgagent.job_steps_log (jobname, stepname, jslstatus, jslresult, jslstart, jslduration, jsloutput) as
SELECT j.jobname,
       ps.jstname AS stepname,
       pj.jslstatus,
       pj.jslresult,
       pj.jslstart,
       pj.jslduration,
       pj.jsloutput
FROM pgagent.pga_jobsteplog pj
         JOIN pgagent.pga_joblog pj2 ON pj2.jlgid = pj.jsljlgid
         JOIN pgagent.pga_job j ON j.jobid = pj2.jlgjobid
         JOIN pgagent.pga_jobstep ps ON ps.jstid = pj.jsljstid
;

create view pgagent.jobs(jobname, jobnextrun, jobenabled, jscname, jscenabled) as
SELECT pj.jobname,
       pj.jobnextrun,
       pj.jobenabled,
       ps.jscname,
       ps.jscenabled
FROM pgagent.pga_job pj
         LEFT JOIN pgagent.pga_schedule ps ON ps.jscjobid = pj.jobid
;

create view pgagent.jobs_log(jobname, jlgstatus, jlgstart, jlgduration) as
SELECT pj.jobname,
       pjl.jlgstatus,
       pjl.jlgstart,
       pjl.jlgduration
FROM pgagent.pga_joblog pjl
         JOIN pgagent.pga_job pj ON pj.jobid = pjl.jlgjobid
;

create view pgagent.jobs_steps
            (jobname, jobnextrun, jobenabled, jstname, jstenabled, jstkind, jstcode, jstdbname, jstonerror) as
SELECT pj.jobname,
       pj.jobnextrun,
       pj.jobenabled,
       pj2.jstname,
       pj2.jstenabled,
       pj2.jstkind,
       pj2.jstcode,
       pj2.jstdbname,
       pj2.jstonerror
FROM pgagent.pga_job pj
         JOIN pgagent.pga_jobstep pj2 ON pj2.jstjobid = pj.jobid
ORDER BY pj2.jstid, pj2.jstjobid
;
 