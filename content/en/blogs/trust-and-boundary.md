+++
date = '2026-10-10T11:58:35+08:00'
lastmod = '2026-10-10T11:58:35+08:00'
draft = false
title = "Trust and Boundary: A Developer's Survival Criteria in the AI Era"
description = 'When writing code approaches zero cost, what becomes scarce is not code but understanding, debuggability, and boundary. A long read on where developers should go.'
tags = ['AI', 'Software Engineering', 'Career', 'Systems Thinking', 'Frontend']
categories = ['Engineering']
author = 'Diogo Ferro'
+++

I heard this story secondhand. A team handed its core module to an agent for a rewrite last year. Tests were green. Code review found nothing. It shipped without incident. Three months later a bug appeared that only triggered under concurrency, and a developer spent two days on it before saying the thing that stuck with me: I cannot tell you how this module works.

The code was not written by him, and it was not written by anyone on his team.

That is the situation I want to talk about. Writing code got cheap. What got expensive? And for anyone who intends to stay in this industry, what is the criterion now?

The criterion did change. It used to be "can you write code." Now it is closer to a different question: did you define the interfaces on this system, and when it breaks, are you the one who goes and finds out. Both answers have to be "you." The AI is not the subject of either sentence.

I am not going to write this up as something tidy, because parts of it I have not figured out. The part I have figured out least is the last section: if entry-level roles really are disappearing, where do the people who were supposed to grow into "the person who can explain the whole system" come from?

Two things need to be said precisely before anything else. Jobs, and training.

## Not disappearing jobs, narrowing entrances

"AI will wipe out a large number of entry-level programming jobs" points in the right direction and overstates the magnitude. The overstatement is what makes the whole argument easy to dismiss, because any engineering lead who is still hiring can produce a counterexample in one sentence.

Here is the decomposition. For work where the requirements are clear and the result is verifiable, the cost of generation has already gone to roughly zero, and that class of job and its pricing get compressed first. That part is real. But "entry-level work" also contains a lot of work whose requirements are vague, that depends on a specific environment, and that needs somebody to be accountable when it fails. Agents cannot take that yet, not because they lack capability, but because the context that work needs is not in the code. And some of the cost comes back: verification, integration, operations, accountability. That work does not vanish, it changes titles.

So I prefer "the structure of jobs is being rearranged and the entrance is narrowing" to "a lot of jobs are disappearing." The difference between rearranged and gone is not a matter of wording. It determines what you should be preparing for.

## After the ladder is pulled up

Software has an old, unglamorous, and extremely effective training mechanism: hire a batch of junior developers, have them write production code, and let production teach them what engineering means.

It is absurdly efficient because it hands over three things at once. Real constraints. Real consequences. A real person who is accountable. Your interface gets called by someone else's module. Your table schema gets changed by another person three months later. Your design flaw wakes you up at two in the morning. None of that is substitutable by a textbook.

The mechanism is being dismantled, for a simple reason. If an agent produces equal or better code at lower cost, why hire someone who needs six months before they are useful.

The popular optimistic answer is that new teaching systems will handle it. I do not accept that answer, not because it must be wrong, but because it treats the hardest link in the chain as a given.

Where the difficulty sits is worth splitting in two.

A playground can train more than people give it credit for. A beginner hand-writes a system from scratch in a sandbox and it goes wrong: modules couple, state refuses to stay contained, fixing one thing breaks three. Those consequences are real, immediate, and reproducible. So replacing real projects with individual practice is a sound direction, and the density of practice in the AI era goes up by orders of magnitude. Construction ability can be trained quite solidly.

Systems thinking does not grow that way. Feedback inside a playground is a closed loop. It is you and your program, and when something breaks you know immediately. That is both its greatest strength and its ceiling. A real system contains three things a playground does not: other people's code, the dimension of time, and the constraints of a protocol. Systems thinking actually grows at the moment when someone else has to change your code. You have to take something you did not write and extend it, and you have to state your boundary clearly enough that they can.

So the crux of educational reconstruction in the AI era, I think, is one thing: put other people back into the feedback loop, rather than building a more realistic and complex sandbox. That conclusion sounds vague. Landing it is not mysterious. Go be upstream in an open source project, where other people's code constrains you. Build something real people actually use. Put your design in front of people who will challenge it. These old methods still work because they all force the same act: producing explanations instead of producing code.

One method I use myself. When learning with an AI, forbid it from giving answers and let it only ask questions. Fei-Fei Li has talked about using Socratic dialogue to learn with AI, and I think that line carries more weight than it appears to: explaining and being accountable are the same ability. If you let someone else think it through for you, you have not thought it through.

Which brings me back to the gap I admitted at the start. There is no mature way to close it in the short term, and my guess is it produces a five-to-ten-year generational break: replacement happens first, the training system arrives later. Saying the window out loud is more useful than pretending it will resolve itself, because it affects at least one thing: whether you are willing to go and replace the training that was taken away.

## What happened on the demand side

To understand why the job structure is consolidating the way it is, you have to look at demand.

One optimistic narrative says AI will bring a new wave of demand, like the web and mobile did. I think the analogy is wrong, and wrong in a way that matters.

Production tools are never the source of demand. Compilers, frameworks, cloud, open source ecosystems: none of them caused the demand for the web. They were carried up by the web and mobile revolutions. Demand comes first, the tools grow alongside it, and then the tools push down cost and widen what can be served. Where demand does not exist, no tool will grow.

What did those two revolutions supply for job growth? A homogeneous, enormous pool of demand. Everyone needed to get online; everyone needed a new phone. "Build one product, serve a few hundred million people" became a viable business, capacity was absorbed by demand, and jobs expanded.

AI did not bring a new homogeneous pool. It did something else: it pushed down the scale threshold at which demand becomes serviceable. Previously only demand that could reach a million people was worth building software for, because the unit cost of serving it was too high, and long-tail demand never entered the market at all. Now that unit cost has fallen within reach, and a large amount of personalized, small-scale demand that was never worth serving is being counted for the first time. So yes, the demand curve is moving up. It is moving up because a steady trickle of small demand became serviceable for the first time, not because a new giant pool fell out of the sky.

That distinction determines structure. It used to be homogeneous demand against a gently declining cost curve, and capacity was absorbed by demand. Now it is long-tail demand against a cliff-edge decline in cost, and personalized demand gets thinner the further you go. This explains why domains dense in entry-level developers and high in homogeneous demand feel the pressure first: homogeneous demand is the easiest thing for standardized tooling to eat. It also explains why the scaling dividend is fading. Every piece of demand has to be understood, designed, and verified on its own. "Build once, replicate infinitely," the largest lever software ever had, is depreciating.

## From "can you write it" to "do you know it's right"

When the cost of generating code goes to roughly zero, the binding constraint has to move. It used to be capacity. Now it is judgment: from "can this code be written" to "how do I know it was written correctly."

To talk about judgment you first have to admit something. Review, tests, and CI have not stopped working, but what they can actually prove is a subject we rarely discuss seriously.

Verification has to cover two layers, and their feedback capability differs enormously. The implementation layer asks whether the code faithfully implements the design. Compilers, types, and tests can answer that, and the agent can test itself. It is already fairly strong there. The design layer asks whether the design expresses real intent. That layer rests almost entirely on business acceptance and domain experts, and the AI will not push back at all.

The danger is that an AI can faithfully implement a wrong design and deliver a highly consistent, highly trustworthy, wrong system. Controllability maxed out, correctness at zero. That is the characteristic accident of the AI era. The nature of the accident changes from "the code was written wrong" to "the design was wrong and nothing in the pipeline was going to push back."

There is a further problem: we can only check against expectations someone has already written down. If the expectation itself is wrong, the tests stay green the whole way.

And correctness is usually not knowable before shipping. In real business, the hard part of verification is rarely "I know the standard, I just did not test it." It is usually that you do not know what the standard is. A lot of anomalies only become visible once data accumulates: at launch you cannot see anything wrong, and two weeks later you notice a conversion rate looks off, or a latency distribution collapses on particular devices. Correctness is a variable that becomes visible over time, not a constant you can confirm once before release.

## What the prompt, harness, loop line is converging on

The methodological progression of the last two years is clear: prompt engineering, then harness engineering, then loop engineering. Many people read it as increasingly sophisticated technique. I think there is only one driver: the feedback signal.

Prompt engineering is stating intent clearly. In essence, one guess. Harness engineering gives the model tools, context, and checkpoints. In essence, one round of feedback, so it can find and correct its own mistakes inside a task. Loop engineering runs it, observes, judges, adjusts, runs again. In essence, it stops depending on a single human judgment. The further along you go, the more it depends on one precondition: whether the acceptance criteria can be judged automatically.

That precondition draws a boundary I find very practical. Where there is no observable signal, loop engineering does not hold. If the "right" of something cannot be expressed as a metric, a contract, a test, or an executable spec, whether the experience is good, whether a product has anything new in it, what counts as correct when departments disagree, then the loop is either lying to itself or degrading into human review. Accept the boundary and loop engineering is engineering. Skip it and it is just a variant of the claim that AI solves everything.

Testing sits in the same place. It is not "avoiding responsibility," it is the executable evidence that I understand this code. But it has to be layered, and the ground truth has to come from a person: if the tests and the implementation are both generated by AI, they share the same blind spot, and what you measured is self-consistency, not correctness.

From there one selection principle follows directly, and it works better than any "how to get AI to write good code" tip, because it answers where not to use it: a module whose acceptance criteria you cannot write down, or whose ground truth you cannot construct, is not a module to hand to an agent.

## I left a loose end on demand

I only told half the demand story, and this loose end I have never resolved, so I will leave it visible.

Homogeneous demand against a gently declining cost curve, long-tail demand against a cliff-edge decline: that structure is clear. But there is one more possibility. If willingness to pay for personalized demand is generally low, does that demand curve barely rise at all? In that case "consolidation" is not a transition state but the new normal. That would change how much weight all my conclusions below can carry, so I am not going to pretend it is not there.

## FDE: from implementation labor to value translator

The popular account of the forward-deployed engineer goes like this: cloud vendors send engineers on site to deploy, and the value that deployment creates is hard to demonstrate. That account is backwards commercially. Enterprise software money is collected precisely at delivery. Implementation, integration, customization, consulting have always been the large line items.

A more accurate description is that the FDE used to do implementation labor: provision the environment, tune parameters, write integration glue, add fields, migrate data. That work has extremely low leverage. It is not reusable, not productizable, and appears on no architecture diagram, so its value was buried in billable hours and the practitioner was not treated as an engineering role.

AI changed the structure of that job. It pushed down the cost of translating business semantics into code, so the FDE's center of gravity moves from implementation to understanding: no longer writing glue personally, but fixing business intent into judgeable acceptance signals and then letting a coding agent implement them. Read that way, the real deliverable of an FDE is not a deployed system. It is a business specification an AI can run to a correct result. The value was never invisible; it was buried in implementation hours and can now be measured on its own. Which is why I think this role is not disappearing in the AI era. It is being promoted.

## Trust = debuggability

Now I have to deal with a question that is usually answered badly: what exactly makes AI-written code less trustworthy.

There is a comforting line that "code written by a person is more trustworthy." I do not think that holds, and it hides the real problem. Counterexamples are easy. Handwritten legacy code that nobody understands: is it a black box? Yes. Is it trustworthy? No. And it is worse than generated code, because at least you can regenerate generated code.

The other direction: code written by an AI, with a design fixed by a person and clear interfaces and acceptance conditions. Considerably more trustworthy than the case above.

So trustworthiness is not a property of the production method. It has exactly one criterion: when this software breaks, can it be debugged. Not "does it have bugs." No software has no bugs, and using defect-freedom as the standard is the same as having no standard. The question is whether, when it breaks, someone is holding the design, can locate it, can reason it through, and can explain why it does what it does.

Following that criterion, there is a question a lot of people wonder about and few say out loud: does typing it out yourself increase trustworthiness? It does not. A handwritten module nobody can debug and a generated module nobody can debug are the same module on this axis. That cuts at everyone, including people who have written code for ten years. Seniority is not trustworthiness.

This also settles the accountability question. Responsibility does not shift because the code came from an AI, and it never lightened because a person typed it. The real change is this: when the code is a black box, responsibility does not disappear, it just has no one who can actually hold it, and it lands on the organization and on the incident. So "an AI cannot be responsible" is a weak argument. The strong one is that you cannot be responsible for what you cannot control, and control requires understanding.

## Entropy got expensive

When code gets cheap, what gets expensive? My answer is not "engineers become more valuable." It is trust, distribution, proprietary data, and entropy.

The first three are old news. Code is no longer a moat; the moat moved to data, channels, and domain access. The fourth is underrated.

When the cost of generating code approaches zero, a system can expand without limit. Previously, adding features meant scheduling and headcount planning, and that cost put a natural brake on boundary expansion. The brake is now loose. An agent can generate modules, adapt scenarios, and clean up legacy endlessly, so technical debt, maintenance cost, and cognitive load become the new scarce constraint.

Push it one step further: a system that has grown past anyone's understanding simultaneously loses debuggability, and therefore loses the capacity to be held responsible. That is the same statement as the previous section.

The design principle has to change with it. It used to be "as long as it runs." Now it is closer to: do not let the system grow past what any person can understand. That sounds conservative. I think it is the most radical design principle of the AI era, because it is the only constraint that preserves debuggability, conceptual integrity, and accountability at the same time.

One common misreading worth clearing up. What large models dissolve is communication overhead, not conceptual integrity. Brooks's argument was never only that communication is expensive. It was also conceptual integrity: good systems come from a small number of consistent minds. The mythical man-month does not die because of AI. It moves. Coding agents cut the cost of translating one person's intent into code without loss, and they cut the cost of transferring one person's intent to another person. But ten agents with ten idioms and nobody able to hold the whole system in their head is a risk that is going up.

That requires an explicit owner, or the chaos gets away from you. Conceptual integrity belongs to a person. There can be a crowd of agents writing, but consistency of design has to be decided and guarded by one specific human being. Do it the other way, let AI design and then find someone to carry the design, and you get exactly the highly consistent, highly trustworthy, wrong system from before.

## Take the frontend as an example

Everything above is a claim about developers in general. The frontend is a concrete instance.

First, a correction. "The frontend role disappeared" is false. "Demand for frontend work is declining" is true. The frontend is dense with entry-level developers and its demand is highly homogeneous. Lists, forms, admin panels, detail pages: the shapes have been stable for a long time. So by the logic above it feels the pressure first. That is structural, not temporary.

It is also true that the decline is not all AI. The overexpansion around 2021, outsourcing migration, and title consolidation from full-stack-ification each explain part of the contraction. Blaming it all on AI is lazy.

Does the frontend still have room for systems work? Yes, and it lands exactly on the criterion above. These are the places where AI-generated code needs someone to back it up. Rendering performance is one: an AI can write the component, but performance decay on specific devices under specific interactions needs a person to locate. State consistency is another, and cross-route, cross-tab, cross-client state synchronisation is where "highly self-consistent and wrong" happens most easily. Cross-client consistency is a protocol and contract design problem. Design system governance is dependency governance in its purest form. Observability and verification infrastructure is even more direct: instrumentation, metrics, anomaly detection, canary releases. That is the precondition for any loop to actually run, and it is pure systems engineering. Above that sits experiment infrastructure: A/B, feature flags, rollback. Once "correctness becomes visible over time" is the normal state, experiment infrastructure is the only thing that makes it visible faster.

Fewer existing positions and higher demands on systems ability. That is what I want a frontend reader to take away. It is not comfort, but it is a direction.

## So what do you actually do

The argument reduces to three actions, and none of them is "improve yourself."

Move your deliverable from code to definition. The source of debuggability is interfaces and acceptance conditions, and that is what "written by a person" always meant. What a person writes is not the implementation, it is the design, the interfaces, and the verification conditions. So your core output should be what this module's contract is, what counts as correct, where the boundary is, and how failure surfaces. A module whose acceptance conditions you cannot write down is a module you do not actually understand, and it should not go to an agent.

Get inside the loop instead of staying outside it. A developer who stays outside degrades into receiving AI output and hoping. A developer inside it is designing the convergence conditions: defining the signal, setting the criteria, deciding when to keep running and when to stop and find a person. The scarce position is not the person who writes good prompts. It is the person who defines what "correct" means.

Keep the design in your hands and actively shrink the system boundary. Entropy got expensive. "I can build bigger" is no longer an advantage; "I can keep the system inside the range of what is understandable" is. In practice that is two moves: interrogate every piece of complexity entering the system about whether it is worth it, and do not hand conceptual integrity to an agent.

I know these three actions do not sound new. Maybe that is because the real change was never in the actions. It was in the criterion. When the criterion changes, the same actions carry entirely different weight.

Back to the developer who spent two days on it. What he ended up doing was rereading the module, drawing the dependencies, writing the interfaces into documentation, and only then making the fix. Nobody asked him to do that. I think that is the group of people who remain in the AI era. Not because of what they can write, but because when something breaks, they are the ones who go and understand it.
