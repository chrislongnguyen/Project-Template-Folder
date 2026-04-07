---
version: "2.0"
status: "Draft"
source_url: "https://www.reddit.com/r/ClaudeAI/comments/1sdjzjx/im_new_to_claude_code_and_would_like_to_make_the/"
source_type: "web-clip"
---
---
  version: "2.0"
  status: Draft
  last_updated: 2026-04-06T17:07:01+07:00
  source_url: https://www.reddit.com/r/ClaudeAI/comments/1sdjzjx/im_new_to_claude_code_and_would_like_to_make_the/
  source_type: web-clip
  ---
  # I'm new to Claude Code and would like to make the best out of my subscription, where can I learn alot about how to use Claude Code in more efficient ways?

  > Clipped from: https://www.reddit.com/r/ClaudeAI/comments/1sdjzjx/im_new_to_claude_code_and_would_like_to_make_the/
  > Date: 2026-04-06T17:07:01+07:00

  IDK where to look for the good videos that actually describe how to use claude code and what it could go well with to make it a better tool. I use it for both fun in projects that i make aswell as in Cybersecurity and ML/Data science.

Any video i find online has a clickbait element to it assuming it'll teach you tricks where its 9 already known tricks, and the 10th is something you have to buy from the creator which sums up my luck about a deeper look into Claude Code. Can anyone recommend any good videos that actually teach you things about Claude Code?

P.S I saw Anthropic themselves have courses on this, are they any good?

---

## Comments

> **clayingmore** · [2026-04-06](https://reddit.com/r/ClaudeAI/comments/1sdjzjx/comment/oej4xqj/) · 13 points
> 
> The Anthropic courses are definitely good.
> 
> The dirtiest of trade secrets is to just ask Claude how to get the most out of Claude Code.
> 
> How do you improve your prompt? Ask Claude. How do you improve your CLAUDE.md? Ask Claude. How do you make a good architecture spec? Ask Claude. What frameworks and dependencies will settle best within your project? Ask Claude.
> 
> Don't take the responses at face value as they may be wrong, but it is great starting point. An active discussion with your LLM of choice creates a Socratic dynamic for quick learning.
> 
> > **bambam020** · [2026-04-06](https://reddit.com/r/ClaudeAI/comments/1sdjzjx/comment/oej6li9/) · 4 points
> > 
> > +1 Exactly what I was going to say. I started on Claude Code about 4 weeks ago. All you really need to think about is some small use cases / projects you want to build. You tell CC and away you go.
> > 
> > One thing I highly recommend is creating a good instructions file (Claude.md). This stipulates how you want Claude to operate. Difference is night and day in terms of what you can get out of CC if you give it clear overall operating instructions.

> **Hsoj707** · [2026-04-06](https://reddit.com/r/ClaudeAI/comments/1sdjzjx/comment/oej50t8/) · 4 points
> 
> Best piece of advice I can give is to just start using it. Don't over think it. Start talking to it and see what it'll do for you.
> 
> For structured learning, the Claude Code in action is a good one to go through [https://anthropic.skilljar.com/claude-code-in-action](https://anthropic.skilljar.com/claude-code-in-action)

> **KH33tBit** · [2026-04-06](https://reddit.com/r/ClaudeAI/comments/1sdjzjx/comment/oejcsaw/) · 3 points
> 
> The way that seems to work for me so far.
> 
> \- Start a new project with Claude (Not co-work or Claude Code)  
> \- Only use voice chat for input, this way you just word vomit what you're thinking  
> \- Outline the thing you're trying to make or achieve to Claude  
> \- Use Claude to write prompts for Claude Code then paste the reports and reponses back to Claude
> 
> The most powerful way I've found so far to get the most from Claude Code is to run it in VS Code with full access to the project.
> 
> Make sure you use plug-ins as needed and ask Claude which ones to use.

> **brunobertapeli** · [2026-04-06](https://reddit.com/r/ClaudeAI/comments/1sdjzjx/comment/oej8o5s/) · 1 points
> 
> Use your sub on codedeckai. Its Claude code but with a better interface.
> 
> There you start with a boilerplate so you save tons of tokens.
> 
> If you will build a website choose the first boilerplate that deploy with one click on vercel.
> 
> If you want to build a sass, choose the one that uses stripe and supabase. Deploys with one click on railway.
> 
> It has even a screen studio clone (video editor) inside. It's mind boggling

> **Fun\_Nebula\_9682** · [2026-04-06](https://reddit.com/r/ClaudeAI/comments/1sdjzjx/comment/oejdbiq/) · 2 points
> 
> skip the youtube stuff honestly. best gains came from:
> 
> CLAUDE.md file in your project root — put your coding standards, project-specific rules, "don't do X" stuff there. claude reads it on every session start. cut my back-and-forth dramatically once i started doing this
> 
> for cybersec/ML specifically, you can put domain constraints directly in there ("prefer uv over pip", "never hardcode api keys") and it follows them without reminding every session
> 
> real productivity comes from building up CLAUDE.md over time + making reusable slash commands for repetitive workflows. that's what no video covers because it's personal to how you work. anthropic courses are fine for basics but won't get you there

> **lmhansen68** · [2026-04-06](https://reddit.com/r/ClaudeAI/comments/1sdjzjx/comment/oejmxjp/) · 2 points
> 
> First step needs to be to turn off sycophants mode. In settings under personal preferences, add the line "don't try to flatter, but also don't try to win".
> 
> That one line will stop Claude from responding like you're a genius, and fill push back on things that may not be a great idea.
> 
> Always discuss your plan with Claude to help fine tune things. Talk to it like you would a helpful colleague.

> **akolomf** · [2026-04-06](https://reddit.com/r/ClaudeAI/comments/1sdjzjx/comment/oej8t1f/) · 3 points
> 
> For coding i like to keep it simple and stupid. I use this [https://github.com/RchGrav/astraeus](https://github.com/RchGrav/astraeus) as the automatic agent Creation tool.
> 
> Just create a folder for whatever project you have. Launch claude in it. Create a short [plan.md](http://plan.md/) file for whatever you are planning for the project together with claude. Run /astraeus, it analyzes the projects contents and creates all necessary agents and workflows. All agents are ready to go and you can create an Implementation plan now with all the details. (after bigger changes, or like on avg once a day, you should run /astraeus again to update all agents and workflows)  
> Also make Claude split plans into phases, and have it write sessionsummaries+Commit to git inbetween each phase.
> 
> Then its basically fire and forget (i do dangerously skip permissions claude, so i dont even have to approve anything).

> **Obvious\_Equivalent\_1** · [2026-04-06](https://reddit.com/r/ClaudeAI/comments/1sdjzjx/comment/oeja8ys/) · 2 points
> 
> Well you asked for simple. Then I’d say try to track the tokens ‘123.000k’ tokens next to the results because there’s where usually subagents pay off. 
> 
> For example rounding up your session with syncing and verifying on docker and running test? Postfix your prompt with “..in Sonnet subagent” and all that verbose testing output will hit our usage 3x less heavy compared to Opus.

> **Large-Excitement777** · [2026-04-06](https://reddit.com/r/ClaudeAI/comments/1sdjzjx/comment/oejatbb/) · 1 points
> 
> First step is to stop trying to convince yourself to use it and just use it.

> **Numerous\_Pickle\_9678** · [2026-04-06](https://reddit.com/r/ClaudeAI/comments/1sdjzjx/comment/oejizgr/) · 1 points
> 
> I think the best way is to understand applied ai in general, I think deeper understanding in it like differnt types of models and what LLMs are capable of and espeically what there going to get better at as time goes on and ai enginnering improves is a good idea to learn.
> 
> and I think a fundemental understanding of digital technology is good, you dont need to understand how to build an app that can use service oriented architecture to scale to millions of concurrent users, but its useful to understand what an API is, for example, Nextjs vs Astro, , etc so you can understand what its roughly doing.

> **No-Equivalent-8726** · [2026-04-06](https://reddit.com/r/ClaudeAI/comments/1sdjzjx/comment/oejm3nr/) · 1 points
> 
> You should create skills.md and provide instructions per projects, and also give some reference files per project.
> 
> And after doing some conversations with Claude, you can ask Claude itself to provide these things, verify once and make changes according to your style, and upload it per project.
> 
> Skill files will be applicable across the projects actually.