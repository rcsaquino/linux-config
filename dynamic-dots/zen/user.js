// General - Startup
user_pref("browser.startup.page", 1);
user_pref("browser.ctrlTab.sortByRecentlyUsed", true);

// Look and Feel - Sidebar and tabs layout
user_pref("zen.view.use-single-toolbar", true);
user_pref("zen.view.show-bottom-border", true);
user_pref("zen.view.show-newtab-button-top", false);

// Look and Feel - Zen URL Bar
user_pref("zen.urlbar.behavior", "float");

// Tab Management - Tab Unloader
user_pref("zen.tab-unloader.enabled", false);

// Tab Management - Pinned Tabs
user_pref("zen.pinned-tab-manager.close-shortcut-behavior", "reset-unload-switch");
user_pref("zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url", true);

// Search
user_pref("browser.search.separatePrivateDefault", false);
user_pref("browser.search.suggest.enabled", true);

// Privacy & Security - Security
user_pref("dom.security.https_only_mode", true);

// Privacy & Security - DNS over HTTPS
user_pref("network.trr.custom_uri", "https://dns.quad9.net/dns-query");
user_pref("network.trr.mode", 2);
user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");

// Others
// user_pref("full-screen-api.transition-duration.enter", "150 150");
// user_pref("full-screen-api.transition-duration.leave", "150 150");
