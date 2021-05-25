# RapidATO

This repo is the development area for the CivicActions Data Science team in 
support of the RapidATO project. 

The work here (mainly in the `R/` Directory) is still in progress. So far,
the team is focused mainly on discovery (what is in the actual SSP documents) 
and analysis to enable the team's compliance SMEs more efficiency in evaluating 
and delivering a Component Library. 

# Overview of the RapidATO Project

The RapidATO (rATO) project has been stood up to evaluate if there is an easier, 
more efficient (read: cheaper and faster) and more effective way to get through 
the required Authority to Operate (ATO) process. The Federal Government operates 
thousands of applications, all of which has to go through the ATO process initially 
and on a regular cycle for refreshes. Each ATO costs the government (read: 
taxpayer) between \$750,000 and \$1,000,000.

What is more: many applications are powered a similar set of tools, processes and 
technology stacks. However, each ATO document (which will be defined shortly) is 
written in a silo. In many cases, Federal personnel start from scratch (or, at 
least, varying starting points) when there are multitudes of reference materials 
they could be using to guide the way. 

The ATO process starts with the creation of a System Security Plan (SSP), which 
is essentially a long list of questions about the system's security controls. 
Ideally the responses to these questions would be categorized as "components". 
This document defines which tools are being used and how. A human (or group of 
humans) then reviews each document to ensure completeness and compliance with 
predefined security requirements. 

# The Value Proposition

The value comes from making this process more efficient. There are a few high 
level opportunities for this efficiency: 

1. Make systems that are measurably more secure
2. Give the SSP author a starting point that is better than a blank document
3. Give the SSP reviewer a head start on identifying the good and bad

## Give the SSP Author a Starting Point

This looks very simple to the author. 

The author enters our web page, selects which components they will be using 
(remember - these are the tools, or applications, or frameworks, etc. that they 
are using to power their application), then is provided a template document from 
which to start. It will show which controls (these are the questions in the SSP) 
are required for each component, with starting text already populated. 

Every system has custom pieces, so it will not be a document that is ready to be 
submitted, but it will be a solid starting point. From there, teams will need to 
document aspects of their system that are unique and may require narratives to be 
written from scratch. The non-custom pieces have the added benefit (in the next 
section) of allowing the reviewer to easily identify which parts of the SSP have 
been modified and which have not. 

There should be an automated verification (at the end of this) that checks the 
doc at some level before the author can submit.

## Give the SSP Reviewer a Head Start 

This templated design enables some nice functionality for the reviewer. I think 
there are some additional functionalities that should be evaluated for the 
reviewer, too. 

Here's what can be provided to the reviewer to aid in the evaluation: 

1. A comprehensive list of the components that are part of the SSP 
2. A differential report (similar to that which GitHub provides when doing a 
merge) which shows the additions (and removals) from the template
3. Identifying any gaps or unneeded additions (this component should have 
additional controls or you've filled in more than you have to for this component)
4. The ability to review the controls for each component or "pivot" to see the 
components in each control
5. Give a score for each control showing the confidence in meeting the security 
requirements, which lets the reviewer spend more time on the more suspicious stuff

Some of this can be automated, so the user is presented with feedback 
automatically. 
