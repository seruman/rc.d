type Address = `http://${string}` | `https://${string}`;
type GitHubParams = {
	addr: Address;
	org: string;
	repo: string;
	issue?: string;
};

function github_params(url: URL): GitHubParams | null {
	const PROJECTS_URL_PATTERN = /https:\/\/github(.*)\.com\/orgs\/(.+)\/projects\/(\d+)/;
	const DEFAULT_PATTERN = /https:\/\/github(.*)\.com\/(.+)\/(.+)/;

	const addr = `${url.protocol}//${url.host}` as Address;

	if (PROJECTS_URL_PATTERN.test(url.href)) {
		const match = url.href.match(PROJECTS_URL_PATTERN);
		if (!match) return null;

		const issueQuery = url.searchParams.get("issue") ?? "";
		if (!issueQuery) return null;

		const [org, repo, issue] = issueQuery.split("|");
		if (!org || !repo || !issue) return null;

		return { addr, org, repo, issue };
	}

	if (DEFAULT_PATTERN.test(url.href)) {
		const match = url.href.match(DEFAULT_PATTERN);
		if (!match) return null;

		const path = url.pathname.slice(1).split("/");
		if (path.length < 2) return null;

		const org = path[0];
		const repo = path[1];
		if (!org || !repo) return null;

		return { addr, org, repo };
	}

	return null;
}

function github_open(path_fn: (params: GitHubParams) => string, new_tab: boolean) {
	return async ({ tab_id }: { tab_id: number }) => {
		const params = github_params(glide.ctx.url);
		if (!params) return;
		const url = path_fn(params);
		if (new_tab) {
			await browser.tabs.create({ url, active: true, openerTabId: tab_id });
		} else {
			await browser.tabs.update(tab_id, { url });
		}
	};
}

const repo_path = (p: GitHubParams) => `${p.addr}/${p.org}/${p.repo}`;
const issues_path = (p: GitHubParams) => (p.issue ? `${repo_path(p)}/issues/${p.issue}` : `${repo_path(p)}/issues`);
const pulls_path = (p: GitHubParams) => `${repo_path(p)}/pulls`;
const godoc_path = (p: GitHubParams) => `https://pkg.go.dev/github.com/${p.org}/${p.repo}`;

glide.autocmds.create("UrlEnter", /https:\/\/github(.*)\.com/, () => {
	glide.buf.keymaps.set("normal", "<C-g>i", github_open(issues_path, false), {
		description: "Open GitHub issues in current tab",
	});
	glide.buf.keymaps.set("normal", "<C-g>I", github_open(issues_path, true), {
		description: "Open GitHub issues in a new tab",
	});
	glide.buf.keymaps.set("normal", "<C-g>r", github_open(repo_path, false), {
		description: "Open GitHub repo root in current tab",
	});
	glide.buf.keymaps.set("normal", "<C-g>R", github_open(repo_path, true), {
		description: "Open GitHub repo root in a new tab",
	});
	glide.buf.keymaps.set("normal", "<C-g>p", github_open(pulls_path, false), {
		description: "Open GitHub PRs in current tab",
	});
	glide.buf.keymaps.set("normal", "<C-g>P", github_open(pulls_path, true), {
		description: "Open GitHub PRs in a new tab",
	});
});

glide.autocmds.create("UrlEnter", { hostname: "github.com" }, () => {
	glide.buf.keymaps.set("normal", "<C-g>g", github_open(godoc_path, false), {
		description: "Open Go docs for this repo",
	});
	glide.buf.keymaps.set("normal", "<C-g>G", github_open(godoc_path, true), {
		description: "Open Go docs for this repo in a new tab",
	});
});
