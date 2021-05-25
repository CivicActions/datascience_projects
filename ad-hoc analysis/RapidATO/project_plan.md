---
title: "rATO Data Science Requirements Doc"
author: "Jake Rozran"
date: "2021-05-03"
---

# Overview

The Rapid ATO (rATO) project has been stood up to evaluate if there is an easier, 
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

# High Level - Where are We Now? 

There is quite a bit of work that has been done. In fact, the reason I have any 
idea of what we need to do is due to the fact that the team has spent time 
researching, organizing, and laying the ground work for this project. At this 
point, the foundation has been laid and the team is working on moving from a 
planing and research phase into a tactical phase. 

Here's the work that have completed: 

1. **Foundational work**: this is the work to convert controls and components 
into something machine readable and export it in a repeatable and documented way
2. **Natural Language Processing (NLP) Foundations**: 

Here are the groups of work that need to be completed:

1. **Data work**: this is the work to identify components, create control text, 
map the components to controls, then automate this discovery process 
(hypothetically using data science - i.e. Natural Language Processing & Graphs). 
2. **Application work**: this is the work to create something that an SSP author 
or ATO evaluator can use to leverage the data science underneath. For example, an 
author may come to a user interface, plug in their website's tools/technologies, 
and be provided with a templated starting SSP to modify. From the other point-of-
view, an evaluator would come into the website to see a submitted SSP along with 
analysis on the submission - how much has been modified from the template, how 
well does the template match the submitted doc, what components have been 
selected, do the selected components have the required controls filled out, etc. 

# Techincal Steps for Remaining Data Work

The idea of the above text is to outline the end vision and the road we've been 
on to get here. As with most things in life, this simplified version leaves out 
a lot of nuance. 

What's left? These are the steps still outstanding to get us to the finish line. 

These are pulled in part from 
[this Google Doc](https://docs.google.com/document/d/1AIWTg_0qZjMYp96Gfij0r7ybC4O1Hpb-G418MiJjTDU/edit?usp=sharing).

## Foundational Work

Though our foundational work is by and large completed, there is are some very 
important tasks yet to complete: 

1. Standardizing the CFACTS export fields and report
2. Documenting the code and artifacts created

## Data Work

Much of the data work so far has been proof of concept and/or manual - this has 
allowed the team to test different technologies and theories. Now that there is 
a solid idea, it is time to automate and formalize the processes to create and 
evaluate the SSPs. 

### For the Authors (SSP Creation)

1. Identify Components (i.e. AWS Cloudwatch and Splunk are components)
2. Map Components to Controls (i.e. this component is governed by these SSP 
controls)
3. Create Reference Control Text for each Component & Control combination (i.e. 
this component should have this setting or configuration for this control)
4. Identify which Components inherit Controls from other Components (i.e. you 
can only access this tool after logging into the AWS server, so therefore the 
access controls are inherited from AWS)

### For the Evaluators

This needs more exploration

