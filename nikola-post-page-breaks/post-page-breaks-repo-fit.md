# post-page-breaks: upstream check and repo fit

Task: split a Nikola post or page into several HTML pages at `PAGE_BREAK` markers.
Repository: https://github.com/getnikola/nikola, pinned at `e5e846092461fc12a23ccb3d46683008e25f8ebd`
(2026-09-26, "Skip WordPress attachments whose URL escapes the files directory (#3907)"), which is
also `origin/master` HEAD at the time of the check (2026-10-06).
Issue: https://github.com/getnikola/nikola/issues/2257 "Support breaking pages/posts into multiple pages" (open).
Method: `my-review-workflow/guides/upstream-repo-fit.md`. `gh` is not installed on this machine, so every
search below went through the GitHub REST search API (`curl https://api.github.com/search/issues?q=repo:getnikola/nikola ...`),
the Discussions HTML search page, and the local clone. Every query string is listed so the check can be rerun.

## Verdict

| Scope Gate point | Verdict | One-line reason |
| --- | --- | --- |
| R1 repo eligibility | PASS | MIT, Python, 2745 stars, last commit 2026-09-26, maintainer active (Kwpolska's "Stop slop" commit 2026-09-20). |
| R2 / P2 no PR implements it | PASS, one documented near-miss | The only PR ever opened for #2257 (#3418, closed unmerged 2020) is a client-side jQuery plugin paginating by paragraph count; the maintainer closed it as the wrong approach and specified the server-side, marker-based design this task implements. No other PR, branch, plugin or fork implements server-side post splitting. |
| R3 not declined, not removed | PASS | The maintainer confirmed in 2020 that the feature is still wanted and invited a new PR; the issue is open; nothing was shipped and removed. |
| R4 / P1 fits the philosophy | PASS | It extends the teaser-marker mechanism and the existing index pagination machinery, needs no JavaScript, and works with all themes through small template edits, which is exactly the maintainer's stated design. |
| P7 not a near-duplicate | PASS locally, platform check pending | No local task touches Nikola; no sibling submission is known. The platform near-duplicate check and Scope Gate remain the authority. |
| AI policy (CONTRIBUTING.rst) | PASS | LLM-assisted PRs are allowed when disclosed; rejection targets "large, significant, previously undiscussed changes". This change was discussed and designed by the maintainer in #2257. |

Main residual risk: the Scope Gate could read the closed PR #3418 as "a closed PR that implements the idea" (R2).
The evidence below shows it implements a different capability (client-side display toggling of one HTML page),
was rejected for exactly that reason, and that the maintainer asked for this server-side design instead. Keep this
section handy for a contest note if the gate raises it.

## 1. Repository eligibility (R1)

```
curl -s https://api.github.com/repos/getnikola/nikola
-> stargazers_count 2745, pushed_at 2026-09-26T19:38:02Z, license MIT, language Python
git log -1 e5e846092  -> Sat Sep 26 23:38:01 2026 +0400  Skip WordPress attachments ... (#3907)
git log --oneline e5e846092..origin/master  -> (empty: base is master HEAD)
recent commits: 2026-09-26 #3907, 2026-09-20 "Stop slop" (Chris Warrick), 2026-06-21 #3900, 2026-04-05 #3833, 2026-04-01 #3837
```

Python is allowed, MIT is on the allowed list, star and activity floors are met. Issues and Discussions are both
enabled and in use.

## 2. The issue and what the maintainer said (R3, R4)

Issue #2257 (opened 2016-02-21 by tritium21): split long posts at a marker such as `.. PAGE_BREAK` into
`/posts/my-post.html`, `/posts/my-post-page-2.html` or `/posts/my-post/index.html`, `/posts/my-post/page-2/index.html`.

Thread, verbatim where it matters:

- ralsina (project founder), 2016-03-09: suggested client-side pagination as a stopgap.
- felixfontein (Nikola core developer), 2016-10-15: "If this is implemented in Nikola, it would be good if also a
  full version of the page/post is created." This is the origin of the optional single-page version.
- hilcharge, 2020-01-15: "Is this feature still desired?"
- **Kwpolska (Chris Warrick, current lead maintainer), 2020-01-15: "Yes, it still is. Feel free to work on it, and to
  ask about any details you are unsure of."**
- **Kwpolska, 2020-06-04, the design statement:** "I think that an implementation of the pagination feature should:
  work and integrate with all themes (with small, single-line changes to templates), not require a special theme
  (we tried that for Jupyter, that means really bad UX), primarily be based on user markers, not a paragraph count
  (just like we do for teasers), not require JS to operate. The implementation would operate with the same/similar
  structure as mentioned in the original issue, and would primarily be a change in how posts are rendered (probably
  in the render_pages task plugin, but the page URLs might also require changes to the Post class or other things)."
- Kwpolska, 2020-09-23: "Multiple HTML pages would be the best approach."

The task follows each point: marker-based like teasers, multiple HTML pages, no JavaScript, works in every built-in
theme (Mako and Jinja) through small template edits, rendering changes in `render_pages` plus page URLs on `Post`.
The issue is still open with no "wontfix" or "declined" label; nobody on the team has declined it since.

Related closed issue #765 "Larger structural units than page" (2013, ralsina) listed "Multi-page stories ...
maybe something with magic comments like teasers?" and was closed in 2017 with "This has been open for 4 years.
Enough is enough." That is a stale-issue cleanup, not a ruling against the feature, and #2257 kept being endorsed
afterwards (2020).

## 3. Pull requests in every state (R2, P2)

### 3.1 PR #3418 "Paginated post" (closed, unmerged, 2020-06-03)

Files: `nikola/data/themes/pagination/assets/css/simplePagination.css` (+203),
`.../js/jquery.simplePagination.js` (+398), `.../js/nikola-pagination.js` (+123), `.../js/jquery.min.js`,
`.../templates/paginated-post.tmpl` (+54), `npm_assets/node_modules/simplePagination/...` (+398).
Description: "pagination functionality, based on javascript for browser-based pagination of long post ...
it is just browser-based, not server-side", page length "hard coded at 10 paragraphs".

Maintainer response (Kwpolska, 2020-06-04): "This implementation is incorrect. It creates a new theme, which only
contains assets and a template, so it isn't a valid Nikola theme. The selected JS library is also worrying because of
a far-reaching CSS." followed by the design statement quoted above, then "I'll close this PR, but feel free to open a
new one with a different approach."

Layer-by-layer overlap with this task (the "public core architecture" test from the problem-solution log):

| Layer | PR #3418 | This task |
| --- | --- | --- |
| Where splitting happens | In the browser, toggling `display` on paragraphs of one HTML page | At build time, producing separate HTML files |
| What decides a page boundary | A fixed count of 10 paragraphs | Author markers (`PAGE_BREAK`), with labels |
| Post model / URLs | Untouched | New per-page destination paths and permalinks, translatable pretty-URL setting |
| Build system | Untouched | Per-page render tasks with declared targets, incremental rebuild dependencies |
| Link handling | None | Every link to an element is retargeted to the page holding it, site-wide |
| Templates | A separate, invalid theme | Navigation added to every built-in theme |
| Sitemap, deploy, translations, feeds | Untouched | All updated |

Nothing from #3418 can be reused; it shares only the user-facing goal. Its rejection is the maintainer's argument
for this design, not against it.

### 3.2 Searches (REST search API, `repo:getnikola/nikola`, issues and PRs, all states)

| Query | Total | Relevant hits |
| --- | --- | --- |
| `page break` | 139 | only #2257 |
| `PAGE_BREAK` | 1 | #2257 |
| `paginate post` | 6 | #2257, PR #3418 |
| `paginated post` | 4 | PR #3418 |
| `multi-page post` | 2 | #765 (see above) |
| `split post` | 59 | none (unrelated: slug_source, templates, teaser source file #3485) |
| `post pagination` | 10 | #2257, PR #3418 |
| `pagebreak` | 1 | #765 |
| `multiple pages post` | 33 | #2257 only |
| `split pages` | 27 | none |
| `page_count` | 0 | none |
| `post pages` / `pages of a post` | 390 / 315 | #2257 only |
| `long posts` | 105 | #2257 only |
| `multipage` | 1 | #765 |
| `read more page` | 83 | none |
| `is:pr pagination` | 6 | #3418 (above); #3067, #3015, #1677 (Atom feeds for indexes); #2589 (taxonomy `page` path argument, merged 2016); #2579 (index page range navigation, merged) |

PR #2589 and #2579 are index/taxonomy pagination, already in the code base and reused here as precedent, not
competing implementations.

### 3.3 Local clone

```
git log --all --oneline -S "PAGE_BREAK"                       -> (nothing)
git log --all --oneline -i --grep="paginat|page break|pagebreak|multi-page|2257"
  -> only index/Atom pagination commits (728dd3720, f78a4be76, c3de0f2be, 1b2e71a2e, bfbb70f2f, 0def2e0ad)
git branch -r -> commentplugins, fix-3450, fix-3552-bootstrap5, use-feedgenerator-redux (none related)
grep -rn -i "page.break|pagebreak|PAGE_BREAK" docs nikola   -> (nothing)
```

### 3.4 Plugins repository and Discussions

- `getnikola/plugins` `v8/` listing (54 plugins) contains no pagination or splitting plugin
  (`category_prevnext`, `slides`, `hierarchical_pages`, `tagged_pages` are unrelated). Searches
  `repo:getnikola/plugins` for `paginate`, `pagination`, `multi-page`: 0 results; `page break`, `split`: unrelated hits.
- GitHub Discussions search (`https://github.com/getnikola/nikola/discussions?discussions_q=...`) for `page break`,
  `paginate post`, `split post`, `multiple pages`, `pagination`: only unrelated threads (#3801 translated slugs,
  #3867 breadcrumbs in notebooks, #3886 TOC as metadata, #3581 customizing templates). No ruling on post splitting.

## 4. Repo fit (judgment, grounded in the code)

1. **Existing mechanism it extends.** The teaser marker: `TEASER_REGEXP` (`nikola/post.py:69`) matches an HTML
   comment in the compiled text, case-insensitively, with an optional `: text` part used as the "Read more" label
   (`post.py:916-934`). `PAGE_BREAK` is recognized the same way, label included. Page naming reuses the index
   pagination conventions: `utils.adjust_name_for_index_path_list` (`utils.py:1741-1781`) gives `index-2.html` /
   `INDEXES_PRETTY_PAGE_URL` paths, the "page %d" message (`messages_en.py:47`, translated in every language) gives
   index titles their ` (page N)` suffix (`nikola.py:2659-2670`). Taxonomy magic links already accept a `page`
   argument (`taxonomies_classifier.py:282-301`, PR #2589), so `link://slug/...?page=N` follows an existing idiom.
2. **Real-world precedent a maintainer recognizes.** WordPress `<!--nextpage-->` (multi-page posts with page links),
   Drupal/Joomla page breaks, and print-style article pagination with a "view all" page, which is felixfontein's
   request in the thread.
3. **Most opinionated parts, and how the description pins them.**
   - URL scheme. The issue suggests `-page-2` names; the task uses `-2` and a translatable `PAGE_BREAK_PRETTY_URL`
     mirroring `INDEXES_PRETTY_PAGE_URL` (index pages use `index-2.html` and `page/2/`), stated in full.
   - Where a language link points when a translation has fewer pages: the description states "that translation's
     page N, or its first page".
   - Comments only at the end of the post (last page and single-page version), and head `prev`/`next` walking the
     pages: both stated, both conventional for paginated articles.
   - The single-page version is opt-in (`PAGE_BREAK_SINGLE_PAGE`, default false) so default output gains no
     duplicate-content page; it adds one UI string, added as `"All on one page": ""` to every language file, which
     is how upstream adds strings (`cb17c4f2a`, "Skip to main content").
4. **Repo health.** Active: maintainer commits in September 2026, issues triaged, CI on GitHub Actions. The pinned
   base suite runs offline in about 45 s (507 passed; the 11 failures are environment-only: `nikola auto` needs
   aiohttp/watchdog, WordPress import needs phpserialize, ipynb needs notebook) and is deterministic apart from
   known output noise (random `rest_code_` ids, gallery image order, timestamps) that the hidden tests avoid.

## 5. Fit with the platform and house rules

- Not READ-shaped: the output set itself changes (new files, build targets, registrations) and a global property
  must hold across the site (every link to an element reaches the page holding it), which is the EDIT shape with a
  STATE component (incremental builds must reconcile page sets and cross-post links).
- Not a published spec or famous algorithm. HTML splitting with ancestor reopening is generic, but the decisive
  parts are Nikola-specific: task generation before compilation, `url_replacer` as the single link chokepoint,
  `post_per_file` registrations consumed by the sitemap, `clean_before_deployment`, translations and two template
  engines.
- Opt-in where output would change: posts without markers render as before (verified on the demo site: identical
  HTML after normalizing the base's own nondeterminism); the single-page version is off by default.
- No leak words anywhere; hidden test files will use an unguessable token.
