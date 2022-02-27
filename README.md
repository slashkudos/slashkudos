# slashkudos

Give and receive kudos from your favorite app using `/kudos` 🎉

This is the main repository for slashkudos used for documentation, planning, and discussions.

## Useful Links

| Link | Description |
| ---- | ----------- |
| [slashkudos](https://github.com/slashkudos) | The GitHub org containing all the projects, documentation and code. |
| [slashkudos/slashkudos](https://github.com/slashkudos/slashkudos) | The main repo that you can create a mono Codespace from. |
| [slashkudos/kudos-api](https://github.com/slashkudos/kudos-api) | The Kudos API repository. Built on AWS using DynamoDB, AppSync GraphQL and Serverless Lambda REST APIs. |
| [slashkudos/kudos-site](https://github.com/slashkudos/kudos-site) | The Kudos marketing website (slashkudos.com) repository. Built with Wordpress, hosted on SiteGround and routed by AWS Route 53. |
| [slashkudos/kudos-twitter](https://github.com/slashkudos/kudos-twitter) | The Kudos Twitter integration. |
| [slashkudos/kudos-web](https://github.com/slashkudos/kudos-web) | The Kudos web app (app.slashkudos.com) repository. Built on AWS with React + TypeScript. |
| <hr/> | <hr/> |
| [slashkudos.com](https://slashkudos.com) | The Kudos marketing site |
| [app.slashkudos.com](https://app.slashkudos.com) | The Kudos web app |
| [@slashkudos][Kudos Twitter] | The Kudos twitter account |

## How It Works

### Giving Kudos

Kudos will be integrated into the apps you already know and love, so no need to learn something new. In Discord, GitHub, Teams, and Slack where the /Kudos is installed, just type `/kudos @user your message here...` to give Kudos.

Twitter works a bit differently - just Tweet [@slashkudos][Kudos Twitter] where you would normally use `/Kudos`. So something like `@slashkudos @user your message here...`.

### Exploring Kudos

After rolling out integrations to several of the [apps we plan to support](#supported-apps), we will provide a central place to view all your Kudos on app.slashkudos.com. This is where you will be able to:

- View Kudos you have received
- View Kudos you have given
- View a universal feed of Kudos

## Supported Apps

I am planning on building integrations for giving kudos from these apps. If you want me to create an integration for one not on here, or you want to help create an integration, please create an issue in this repo.

```
- Discord
- GitHub
- Microsoft Teams
- Slack
- Twitter
```

## Features

Features will be rolled out in a series of phases. At a high-level, we will focus on setting up the proper integrations to give and receive Kudos on the most popular apps first. Then we will focus on the exploration and reporting piece on app.slashkudos.com.

See [The Slash Kudos Project](https://github.com/orgs/slashkudos/projects/1/views/1) for a more in-depth plan.

| # | Phase | Features | ETA |
| :-: | ----- | -------- | ---
| 1 | Social networking apps | Twitter Integration | December 2022
| 2 | Open source developer apps | - Discord<br/>- GitHub | TBD
| 3 | Enterprise instant messaging apps | - Slack<br/>- Microsoft Teams | TBD
| 4 | Central UI for Kudos (app.slashkudos.com) | - View the public Kudos feed<br/>- View Kudos you received<br/>- View Kudos you gave | TBD
| TBD | app.slashkudos.com | Create a personal profile and associate several app accounts | TBD
| TBD | app.slashkudos.com | Create a company account for internal Kudos | TBD
| TBD | GitHub Private | Give Kudos from private repos and keep them private | TBD
| TBD | SSO | Use SSO for company and personal profiles | TBD

<!-- Links -->
[Kudos Twitter]: https://twitter.com/slashkudos
