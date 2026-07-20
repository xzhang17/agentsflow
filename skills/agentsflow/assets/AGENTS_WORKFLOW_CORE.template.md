# Agents Flow: @@AGENTS_SLOT:TASK_TITLE@@

<!-- Agents Flow skill: @@AGENTS_SLOT:SKILL_VERSION@@ -->

## Goal

@@AGENTS_SLOT:GOAL@@

## Context

@@AGENTS_SLOT:CONTEXT@@

## Inputs

@@AGENTS_SLOT:INPUTS@@

## Selected Task Profiles

@@AGENTS_SLOT:SELECTED_PROFILE_IDS@@

## Requirements

@@AGENTS_SLOT:PROMPT_REQUIREMENTS@@

## Facts for PLAN to Discover

@@AGENTS_SLOT:PLAN_DISCOVERABLE_FACTS@@

## Validation

@@AGENTS_SLOT:VALIDATION_EXPECTATIONS@@

## Stopping Condition

@@AGENTS_SLOT:STOPPING_DETAILS@@

Default: PLAN stops after the requested result is produced, every committed validation criterion is accounted for, authorized housekeeping is complete, and the final report is delivered. If continuation becomes genuinely impossible, PLAN sends a blocked notice under the canonical safety rules.
