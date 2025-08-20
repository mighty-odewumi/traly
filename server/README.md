# Traly

[![ICP Badge](https://img.shields.io/badge/Built%20on-ICP-blueviolet)](https://internetcomputer.org/)
[![Motoko](https://img.shields.io/badge/Language-Motoko-orange)](https://dfinity.org/developers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

Traly is a gamified email management tool designed to help users clean up their Gmail inbox efficiently while earning rewards for positive habits. By connecting to a user's Gmail account (mocked in this demo), Traly categorizes emails into Important, Normal, and Spam, and assigns points for actions like reading important emails, archiving normals, deleting or unsubscribing from spam. Points can be tracked per user, with potential for rewards and a leaderboard.

This backend is built entirely on the Internet Computer Protocol (ICP) using Motoko, ensuring decentralized, tamper-proof storage and execution. For this hackathon submission, all Gmail interactions are **mocked** using in-memory data structures—no real API calls are made to Gmail. This allows the canister to run standalone in environments like ICP Playground or local dfx deployments without external dependencies. In a production version, real Gmail API integration via ICP HTTPS outcalls would be added (see Future Work section).

**Important Note on Mocked Data**: For this current submission, we focus on the core gamification and ICP integration, and have simulated Gmail data and actions. The project has the Motoko canister handling all logic, state, and testing.

## Features

- **User Authentication**: Mocked sign-in (assumes user is authenticated).
- **Email Categorization**: Emails are pre-categorized as Important, Normal, or Spam in the mock data.
<!-- - **Actions with Gamification**:
  - Mark as Read: +5 points if Important and unread.
  - Archive: +2 points if Normal; moves to archive.
  - Delete: +3 points if Spam.
  - Unsubscribe: +10 points if Spam; removes from inbox.
- **Point Tracking**: Accumulates points per action, stored in canister state. -->
- **Inbox Fetching**: Returns current inbox state.
- **Testing**: Built-in `runTests` function to simulate actions and log before/after states for inbox, archive, and points.
- **Persistence**: Uses stable variables for inbox and archive to survive upgrades.
- **Decentralized**: Runs on ICP, with potential for multi-user support via Principals.

## Tech Stack

- **Language**: Motoko
- **Platform**: Internet Computer (ICP)
- **Dependencies**: Base Motoko libraries (Buffer, Debug, Nat, Text, Iter)
- **Deployment**: dfx (DFINITY SDK)

## Installation and Setup

### Prerequisites
- Install the DFINITY SDK (dfx): Follow [official instructions](https://internetcomputer.org/docs/current/developer-docs/getting-started/install).
- Node.js (for dfx, if needed).
- Clone the repo: `git clone https://github.com/mighty-odewumi/traly.git`.

### Local Development
1. Navigate to the project's server directory containing the Motoko canister code.
```cd traly/server```
2. Start the local ICP replica: `dfx start`.
3. Deploy the canister: `dfx deploy traly_backend`.
4. Interact via dfx commands or ICP Playground.

### dfx.json Configuration
The repo includes a `dfx.json` file to confirm ICP integration:

```json
{
  "canisters": {
    "traly_backend": {
      "main": "src/main.mo",
      "type": "motoko"
    }
  },
  "defaults": {
    "build": {
      "args": "",
      "packtool": ""
    }
  },
  "output_env_file": ".env",
  "version": 1
}
```

## Usage

### Canister Functions
All functions are public and async where appropriate. Call them via `dfx canister call`.

- **initInbox()**: Initializes mock emails (call once after deployment).
- **fetchAllEmails()**: Returns array of current inbox emails.
- **markAsRead(id: Nat)**: Marks email as read, adds points if applicable.
- **deleteEmail(id: Nat)**: Deletes email, adds points if spam.
- **archiveEmail(id: Nat)**: Archives email, adds points if normal.
- **unsubscribe(id: Nat)**: Unsubscribes (deletes) spam email, adds points.
- **runTests()**: Runs sequential tests, logging states and points.

Example dfx calls:
```
dfx canister call traly_backend runTests
dfx canister call traly_backend fetchAllEmails
dfx canister call traly_backend markAsRead 4
dfx canister call traly_backend deleteEmail 3
```

### Mock Data
The backend starts with 5 sample emails:
- ID 1: Important, unread.
- ID 2: Spam, unread.
- ID 3: Normal, unread.
- ID 4: Spam, unread.
- ID 5: Normal, unread.

Actions update in-memory state (persistent via stable vars).

## Testing

Run `dfx canister call traly_backend runTests` to execute automated tests. Output logs to console:
- Initial inbox.
- After each action: Updated inbox

For manual testing:
- Call `fetchAllEmails` before/after actions.
- Verify points via logs (extend with a getPoints function if needed).


## Limitations and Future Work

- **Mocked Gmail**: No real sync; data is simulated for demo. In prod, we plan to integrate Gmail API via ICP HTTPS outcalls.
- **Single-User**: Assumes one user; extend with Principal-based maps for multi-user.
- **No Leaderboard/Rewards Yet**: Points are not tracked and ranked/converted (to be added in v2).

## Contributing
Fork, PR, or open issues. Follow Motoko best practices

## Acknowledgments

Built for WCHL25. Thanks to DFINITY for ICP tools.
