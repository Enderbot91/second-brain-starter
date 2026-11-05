---
type: dashboard
created: 2026-11-05
tags:
  - live-projects
  - dashboard
---

# 🟢 Live Projects

> [!info]- How this board works (click to expand)
> This board renders itself from the project card notes in `04_Dashboards/Project_Cards/`. To change a project's status, edit that card's frontmatter. The board redraws on its own.
> - **status**: `waiting` (on you) · `active` · `paused` (deliberately parked, not dead) · `closed`
> - **progress**: 0 to 100, drives the bar
> - **stage / blocker / next / updated / link**: shown on the card
> - A project is **live until its card is set to `closed`**. Age alone never retires it. New session, "what's live?" means this board. Closed cards are kept 30 days, then delete the file.

```dataviewjs
const order = { waiting: 0, active: 1, paused: 2, closed: 3 };
const meta = {
  waiting: { title: "🔴 Waiting on {{operator}}", accent: "#e5534b" },
  active:  { title: "🟢 Active",            accent: "#2ea043" },
  paused:  { title: "⏸️ Paused",             accent: "#d29922" },
  closed:  { title: "✅ Recently closed",   accent: "#8b949e" },
};

const cards = dv.pages('"04_Dashboards/Project_Cards"')
  .where(p => p.type === "project-card")
  .sort(p => order[p.status] ?? 9);

// ---- summary strip ----
const counts = { waiting: 0, active: 0, paused: 0, closed: 0 };
for (const p of cards) if (counts[p.status] !== undefined) counts[p.status]++;
const strip = dv.container.createEl("div");
strip.setAttr("style", "display:flex;gap:14px;flex-wrap:wrap;margin:4px 0 18px;font-size:0.95em;");
for (const s of ["waiting","active","paused","closed"]) {
  const b = strip.createEl("div");
  b.setAttr("style", `padding:6px 12px;border-radius:8px;background:${meta[s].accent}22;border:1px solid ${meta[s].accent}55;`);
  b.innerHTML = `<b style="color:${meta[s].accent}">${counts[s]}</b> &nbsp;${meta[s].title.replace(/^\S+\s/,"")}`;
}

const bar = (n) => {
  const pct = Math.max(0, Math.min(100, Number(n) || 0));
  const filled = Math.round(pct / 10);
  return "▓".repeat(filled) + "░".repeat(10 - filled) + `  ${pct}%`;
};

for (const status of ["waiting", "active", "paused", "closed"]) {
  const group = cards.where(p => p.status === status);
  if (group.length === 0) continue;
  const m = meta[status];
  const h = dv.container.createEl("h3");
  h.setText(`${m.title}  (${group.length})`);
  h.setAttr("style", `border-bottom:2px solid ${m.accent};padding-bottom:4px;`);

  for (const p of group) {
    const card = dv.container.createEl("div");
    card.setAttr("style", `border:1px solid var(--background-modifier-border);border-left:4px solid ${m.accent};border-radius:8px;padding:10px 14px;margin:8px 0;background:var(--background-secondary);`);

    // title row
    const top = card.createEl("div");
    top.setAttr("style", "display:flex;justify-content:space-between;align-items:baseline;gap:10px;flex-wrap:wrap;");
    const name = top.createEl("span");
    name.setAttr("style", "font-weight:600;font-size:1.05em;");
    if (p.link && p.link.markdown) dv.el("span", p.link.markdown(), { container: name });
    else name.setText(p.project);
    const rightMeta = top.createEl("span");
    rightMeta.setAttr("style", "font-size:0.8em;opacity:0.7;");
    rightMeta.setText(`${p.area ?? ""}${p.updated ? " · upd " + String(p.updated).slice(0,10) : ""}`);

    // progress bar
    const pbar = card.createEl("div");
    pbar.setAttr("style", `font-family:var(--font-monospace);font-size:0.9em;color:${m.accent};letter-spacing:1px;margin:4px 0;`);
    pbar.setText(bar(p.progress));

    // stage
    if (p.stage) {
      const st = card.createEl("div");
      st.setAttr("style", "font-size:0.9em;margin:2px 0;");
      st.setText("• " + p.stage);
    }
    // blocker / next
    if (p.blocker) {
      const bl = card.createEl("div");
      bl.setAttr("style", "font-size:0.9em;margin:2px 0;color:#e5534b;");
      bl.setText("⛔ " + p.blocker);
    }
    if (p.next) {
      const nx = card.createEl("div");
      nx.setAttr("style", "font-size:0.9em;margin:2px 0;opacity:0.85;");
      nx.setText("→ " + p.next);
    }
    if (p.closed) {
      const cl = card.createEl("div");
      cl.setAttr("style", "font-size:0.8em;opacity:0.6;margin-top:2px;");
      cl.setText("closed " + String(p.closed).slice(0,10));
    }
  }
}
```

---

> [!tip]- Plain-table fallback (if DataviewJS is off)
> If the board above is blank, DataviewJS is not enabled. Enable it in **Settings → Community plugins → Dataview → Enable JavaScript Queries**, then reload. This table always works:
>
> ```dataview
> TABLE WITHOUT ID link AS "Project", status, progress + "%" AS "Prog", stage AS "Stage", blocker AS "⛔ Blocked on", updated AS "Updated"
> FROM "04_Dashboards/Project_Cards"
> WHERE type = "project-card"
> SORT status ASC, progress DESC
> ```
