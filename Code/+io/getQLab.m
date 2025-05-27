function [question_labels,theme] = getQLab()

question_labels = {
    'Diversity Statement';
    'Code of Conduct';
    'Green Initiatives';
    'Lab Language';
    'Incident Reporting';
    'Mental Health';
    'Conflict Resolution';
    'Shared Calendar';

    'Lab Members List';
    'Work-Life Balance';
    'Meeting Schedule';
    'Responsibilities';
    'Onboarding';
    'Resource Access';
    'Lab Feedback';
    'Individual Feedback';
    'Normalise Failures';
    'Record-Keeping';
    'PhD Committee';

    'Authorship Policy';
    'Ambitions for Roles';
    'Conferences';
    'Prior Work';
    'Postdoc Funding';
    'Visa Support';
    'Reference Letters';
    'Leaving the Lab';
    'Core Skills';
    'Lab Updates'
    'Interview Process'
};
theme.names = {'Policies','Teams','Careers'};
theme.questions(1:8) = 0;
theme.questions(9:19) = 1;
theme.questions(20:30) = 2;
end

% I commit to publicly document a diversity statement.
% I commit to publicly document the lab code of conduct: emphasise welfare, equity and integrity.
% I commit to publicly document green initiatives in the lab and any explicit rules related to sustainability.
% I commit to publicly document the common lab language and any institutional language requirements.
% I commit to document the procedure for reporting bullying and/or harassment.
% I commit to document available resources to support mental health.
% I commit to document the procedure for raising lab or inter-personal issues.
% I commit to establish a shared lab calendar for members to indicate if they are away, at conferences etc.
% I commit to publicly document a list of lab members and alumni.
% I commit to publicly document my expectations for working hours, remote working, and vacation.
% I commit to publicly document an overview of the regular meetings in the lab, and my expectations for participation.
% I commit to publicly document the responsibilities of each lab role and the training provided.
% I commit to document the onboarding procedure for new lab members.
% I commit to document how equal access to lab resources across lab members is maintained.
% I commit to establish annual lab-wide feedback sessions.
% I commit to establish annual bilateral feedback and appraisal sessions for each lab member.
% I commit to establish annual lab-wide meetings to normalise failures.
% I commit to establish a mechanism to record key outcomes from each 1-on-1 meeting.
% I commit to establish a “PhD Steering Committee” to annually monitor progress and mediate feedback.
% I commit to publicly document which contributions constitute authorship on a scientific paper.
% I commit to publicly document my ambitions for the duration and publication outputs for each lab role.
% I commit to publicly document expectations and funding for conference/summer school attendance.
% I commit to publicly document guidelines for completing previous work after joining the lab.
% I commit to publicly document the process for funding Postdocs.
% I commit to publicly document the visa-support available to overseas applicants.
% I commit to document the procedure for requesting reference letters.
% I commit to document the procedure for leaving the lab, including an exit interview.
% I commit to establish annual lab-wide meetings to review training and outcomes for “core skills”.
% I commit to establish a mechanism for sharing lab management updates. 
% I commit to establish an objective and equitable interview process.    		

