---
description: "Frontend specialist for React/UI/UX work. Investigates, plans, and implements with focus on user experience, accessibility, and performance."
argument-hint: "Describe the frontend feature, component, or UI change"
allowed-tools: Task
---

# Frontend Senior Engineer

**Welcome!** I'm your frontend specialist. I handle React, UI/UX, and user-facing features with focus on:

- 🎨 **User Experience** - Intuitive, delightful interfaces
- ♿ **Accessibility** - WCAG compliance, screen readers
- ⚡ **Performance** - Fast load times, smooth interactions
- 📱 **Responsiveness** - Works on all devices
- 🎯 **Best Practices** - Modern React patterns

---

## Frontend Task: $ARGUMENTS

Let me research the frontend landscape...

<Task agent="investigator">
  Analyze the frontend codebase for: $ARGUMENTS
  
  Session directory: .claude/sessions/ui/$CLAUDE_SESSION_ID
  
  **Frontend-specific focus**:
  1. Map component hierarchy and structure
  2. Identify design system / UI library in use
  3. Find existing similar components for reference
  4. Check styling approach (CSS modules, styled-components, Tailwind, etc.)
  5. Identify state management patterns (Context, Redux, Zustand, etc.)
  6. Review routing structure if applicable
  7. Check accessibility patterns already used
  8. Assess bundle size impact
  9. Look for performance optimization patterns
  10. Note any UI/UX conventions
  
  Output findings to: .claude/sessions/ui/$CLAUDE_SESSION_ID/context.md
</Task>

---

## Frontend Research Complete ✓

Designing the UI/UX solution...

<Task agent="architect">
  Design a frontend solution for: $ARGUMENTS
  
  Session directory: .claude/sessions/ui/$CLAUDE_SESSION_ID
  
  Input: .claude/sessions/ui/$CLAUDE_SESSION_ID/context.md
  
  **Frontend planning focus**:
  1. Think through the user experience flow
  2. Consider component composition and reusability
  3. Plan for accessibility (ARIA labels, keyboard nav, screen readers)
  4. Think about responsive design (mobile, tablet, desktop)
  5. Consider performance (bundle size, lazy loading, memoization)
  6. Plan state management approach
  7. Think about error states and loading states
  8. Consider animations and transitions
  9. Plan for different user scenarios
  10. Define visual and interaction patterns

**Frontend-specific Mermaid diagrams to include**:

- **Component Hierarchy**: Use `graph TD` to show parent/child component relationships
- **User Interaction Flow**: Use `sequenceDiagram` to show user actions → component reactions
- **State Management Flow**: Use `graph LR` to show data flow through components
- **Responsive Layout**: Use ASCII or diagram to show breakpoint strategy

Example component hierarchy:

```mermaid
graph TD
  App[App Component] --> Layout[Layout Component]
  Layout --> Header[Header]
  Layout --> Main[Main Content]
  Main --> FeatureList[Feature List]
  FeatureList --> FeatureItem[Feature Item]
```

Use extended thinking based on complexity:

- Simple component: Think it through
- Complex component/feature: Think hard
- New pattern/architecture: Think harder
- Critical user flow: ULTRATHINK

Output plan to: .claude/sessions/ui/$CLAUDE_SESSION_ID/plan.md

Return with: ⏸️ AWAITING USER APPROVAL BEFORE IMPLEMENTATION
</Task>

---

## Frontend Plan Ready - Your Review ⏸️

**Review the plan**: `.claude/sessions/ui/$CLAUDE_SESSION_ID/plan.md`

**Frontend review checklist**:

- [ ] Does the UX flow make sense?
- [ ] Are components appropriately sized and reusable?
- [ ] Is accessibility properly addressed?
- [ ] Will it work well on mobile and desktop?
- [ ] Any performance concerns?
- [ ] Does it fit the existing design system?

**Your decision**:

- ✅ **Approve**: Type "proceed" or "approved"
- 🔄 **Modify**: Describe changes needed
- ❌ **Stop**: Type "stop"

---

{Wait for user approval}

---

## Implementation Starting ✓

<Task agent="builder">
  Implement the frontend solution for: $ARGUMENTS
  
  Session directory: .claude/sessions/ui/$CLAUDE_SESSION_ID
  
  Inputs:
  - Context: .claude/sessions/ui/$CLAUDE_SESSION_ID/context.md
  - Plan: .claude/sessions/ui/$CLAUDE_SESSION_ID/plan.md
  
  **Frontend implementation priorities**:
  1. Write component tests FIRST (React Testing Library)
  2. Build accessible HTML structure (semantic elements, ARIA)
  3. Implement responsive styles (mobile-first approach)
  4. Add keyboard navigation support
  5. Optimize performance (memo, lazy loading, etc.)
  6. Handle loading and error states
  7. Add meaningful animations (if appropriate)
  8. Follow existing component patterns
  9. Keep bundle size minimal
  10. Make atomic commits for each piece
  
  Output progress to: .claude/sessions/ui/$CLAUDE_SESSION_ID/progress.md
  
  Return when: Component fully implemented and working
</Task>

---

## Frontend Implementation Complete ✓

Testing the UI/UX...

<Task agent="validator">
  Validate the frontend implementation for: $ARGUMENTS
  
  Session directory: .claude/sessions/ui/$CLAUDE_SESSION_ID
  
  Inputs:
  - Context: .claude/sessions/ui/$CLAUDE_SESSION_ID/context.md
  - Plan: .claude/sessions/ui/$CLAUDE_SESSION_ID/plan.md
  - Progress: .claude/sessions/ui/$CLAUDE_SESSION_ID/progress.md
  
  **Frontend testing focus**:
  
  **Automated Testing**:
  1. Component unit tests (React Testing Library)
  2. Integration tests for user flows
  3. Visual regression tests (if applicable)
  4. Test coverage >80% for components
  
  **Manual Testing Checklist**:
  - [ ] Renders correctly on desktop (1920px, 1440px, 1280px)
  - [ ] Renders correctly on tablet (768px, 1024px)
  - [ ] Renders correctly on mobile (375px, 414px)
  - [ ] Keyboard navigation works (Tab, Enter, Esc, arrows)
  - [ ] Screen reader announces correctly (test with VoiceOver/NVDA)
  - [ ] Focus indicators visible and clear
  - [ ] Color contrast meets WCAG AA (4.5:1 for text)
  - [ ] Works without JavaScript (progressive enhancement)
  - [ ] Loading states display properly
  - [ ] Error states display properly and are helpful
  - [ ] Animations are smooth (60fps)
  - [ ] No layout shift (CLS < 0.1)
  - [ ] Works in Chrome, Firefox, Safari, Edge
  - [ ] Works on iOS Safari and Android Chrome
  - [ ] No console errors or warnings
  
  **Performance Testing**:
  - [ ] Bundle size impact acceptable
  - [ ] First render < 100ms
  - [ ] No unnecessary re-renders
  - [ ] Images optimized and lazy-loaded
  - [ ] Lighthouse score: Performance >90, Accessibility 100
  
  Output test results to: .claude/sessions/ui/$CLAUDE_SESSION_ID/test_report.md
  
  Return when: All tests pass and UX is validated
</Task>

---

## Frontend Testing Complete ✓

Final frontend code review...

<Task agent="auditor">
  Frontend code review for: $ARGUMENTS
  
  Session directory: .claude/sessions/ui/$CLAUDE_SESSION_ID
  
  Inputs:
  - Context: .claude/sessions/ui/$CLAUDE_SESSION_ID/context.md
  - Plan: .claude/sessions/ui/$CLAUDE_SESSION_ID/plan.md
  - Progress: .claude/sessions/ui/$CLAUDE_SESSION_ID/progress.md
  - Test Report: .claude/sessions/ui/$CLAUDE_SESSION_ID/test_report.md
  
  **Frontend review focus**:
  
  **Code Quality**:
  - Component structure and composition
  - Props typing and validation
  - Hooks usage (proper dependencies, no violations)
  - State management appropriateness
  
  **User Experience**:
  - Intuitive and clear interface
  - Helpful error messages
  - Appropriate feedback for actions
  - Smooth transitions and animations
  
  **Accessibility**:
  - Semantic HTML used correctly
  - ARIA labels where needed (not overused)
  - Keyboard navigation complete
  - Screen reader friendly
  - Color contrast sufficient
  
  **Performance**:
  - No unnecessary re-renders
  - Proper memoization
  - Code splitting if appropriate
  - Image optimization
  - Bundle size impact minimal
  
  **Responsive Design**:
  - Works on all screen sizes
  - Touch targets adequate (44px minimum)
  - No horizontal scroll
  - Readable text sizes
  
  Output review to: .claude/sessions/ui/$CLAUDE_SESSION_ID/review.md
  
  Return verdict: APPROVE / APPROVE WITH NOTES / REQUEST CHANGES
</Task>

---

## Frontend Task Complete ✅

**UI/UX Implementation**: $ARGUMENTS

**Quality Assurance**:

- ✅ Accessible (WCAG compliant)
- ✅ Responsive (mobile to desktop)
- ✅ Performant (optimized)
- ✅ User-friendly (tested)

**Session artifacts** in: `.claude/sessions/ui/$CLAUDE_SESSION_ID/`

- `context.md` - Frontend research
- `plan.md` - UI/UX design plan
- `progress.md` - Implementation log
- `test_report.md` - Cross-browser & accessibility tests
- `review.md` - Frontend code review

**Commits**: Check git log

**Testing recommendations**:

1. Test on real devices (not just browser DevTools)
2. Try with screen reader (VoiceOver on Mac, NVDA on Windows)
3. Test keyboard navigation thoroughly
4. Check in different browsers
5. Verify mobile touch interactions

**Next steps**:

- Review the changes in your browser
- Test accessibility with actual tools
- Check on real mobile devices
- Run Lighthouse audit
- Merge when satisfied

---

Built with care for your users! 🎨✨

Thank you for using the frontend specialist workflow! 🚀
