CREATE TABLE archive (
 ar_id INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
 ar_namespace INTEGER NOT NULL default 0,
 ar_title TEXT  NOT NULL default '',
 ar_text BLOB NOT NULL,
 ar_comment BLOB NOT NULL,
 ar_user INTEGER  NOT NULL default 0,
 ar_user_text TEXT  NOT NULL,
 ar_timestamp BLOB NOT NULL default '',
 ar_minor_edit INTEGER NOT NULL default 0,
 ar_flags BLOB NOT NULL,
 ar_rev_id INTEGER ,
 ar_text_id INTEGER ,
 ar_deleted INTEGER  NOT NULL default 0,
 ar_len INTEGER ,
 ar_page_id INTEGER ,
 ar_parent_id INTEGER  default NULL,
 ar_sha1 BLOB NOT NULL default '',
 ar_content_model BLOB DEFAULT NULL,
 ar_content_format BLOB DEFAULT NULL
 );
CREATE TABLE category (
 cat_id INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
 cat_title TEXT  NOT NULL,
 cat_pages INTEGER  NOT NULL default 0,
 cat_subcats INTEGER  NOT NULL default 0,
 cat_files INTEGER  NOT NULL default 0
 );
CREATE TABLE categorylinks (
 cl_from INTEGER  NOT NULL default 0,
 cl_to TEXT  NOT NULL default '',
 cl_sortkey BLOB NOT NULL default '',
 cl_sortkey_prefix TEXT  NOT NULL default '',
 cl_timestamp TEXT NOT NULL,
 cl_collation BLOB NOT NULL default '',
 cl_type TEXT NOT NULL default 'page'
 );
CREATE TABLE change_tag (
 ct_rc_id INTEGER NULL,
 ct_log_id INTEGER NULL,
 ct_rev_id INTEGER NULL,
 ct_tag TEXT NOT NULL,
 ct_params BLOB NULL
 );
CREATE TABLE externallinks (
 el_id INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
 el_from INTEGER  NOT NULL default 0,
 el_to BLOB NOT NULL,
 el_index BLOB NOT NULL
 );
CREATE TABLE filearchive (
 fa_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
 fa_name TEXT  NOT NULL default '',
 fa_archive_name TEXT  default '',
 fa_storage_group BLOB,
 fa_storage_key BLOB default '',
 fa_deleted_user INTEGER,
 fa_deleted_timestamp BLOB default '',
 fa_deleted_reason text,
 fa_size INTEGER  default 0,
 fa_width INTEGER default 0,
 fa_height INTEGER default 0,
 fa_metadata BLOB,
 fa_bits INTEGER default 0,
 fa_media_type TEXT default NULL,
 fa_major_mime TEXT default "unknown",
 fa_minor_mime BLOB default "unknown",
 fa_description BLOB,
 fa_user INTEGER  default 0,
 fa_user_text TEXT ,
 fa_timestamp BLOB default '',
 fa_deleted INTEGER  NOT NULL default 0,
 fa_sha1 BLOB NOT NULL default ''
 );
CREATE TABLE hitcounter (
 hc_id INTEGER  NOT NULL
 );
CREATE TABLE image (
 img_name TEXT  NOT NULL default '' PRIMARY KEY,
 img_size INTEGER  NOT NULL default 0,
 img_width INTEGER NOT NULL default 0,
 img_height INTEGER NOT NULL default 0,
 img_metadata BLOB NOT NULL,
 img_bits INTEGER NOT NULL default 0,
 img_media_type TEXT default NULL,
 img_major_mime TEXT NOT NULL default "unknown",
 img_minor_mime BLOB NOT NULL default "unknown",
 img_description BLOB NOT NULL,
 img_user INTEGER  NOT NULL default 0,
 img_user_text TEXT  NOT NULL,
 img_timestamp BLOB NOT NULL default '',
 img_sha1 BLOB NOT NULL default ''
 );
CREATE TABLE imagelinks (
 il_from INTEGER  NOT NULL default 0,
 il_to TEXT  NOT NULL default ''
 );
CREATE TABLE interwiki (
 iw_prefix TEXT NOT NULL,
 iw_url BLOB NOT NULL,
 iw_api BLOB NOT NULL,
 iw_wikiid TEXT NOT NULL,
 iw_local INTEGER NOT NULL,
 iw_trans INTEGER NOT NULL default 0
 );
CREATE TABLE ipblocks (
 ipb_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
 ipb_address BLOB NOT NULL,
 ipb_user INTEGER  NOT NULL default 0,
 ipb_by INTEGER  NOT NULL default 0,
 ipb_by_text TEXT  NOT NULL default '',
 ipb_reason BLOB NOT NULL,
 ipb_timestamp BLOB NOT NULL default '',
 ipb_auto INTEGER NOT NULL default 0,
 ipb_anon_only INTEGER NOT NULL default 0,
 ipb_create_account INTEGER NOT NULL default 1,
 ipb_enable_autoblock INTEGER NOT NULL default '1',
 ipb_expiry BLOB NOT NULL default '',
 ipb_range_start BLOB NOT NULL,
 ipb_range_end BLOB NOT NULL,
 ipb_deleted INTEGER NOT NULL default 0,
 ipb_block_email INTEGER NOT NULL default 0,
 ipb_allow_usertalk INTEGER NOT NULL default 0,
 ipb_parent_block_id INTEGER default NULL
 );
CREATE TABLE iwlinks (
 iwl_from INTEGER  NOT NULL default 0,
 iwl_prefix BLOB NOT NULL default '',
 iwl_title TEXT  NOT NULL default ''
 );
CREATE TABLE job (
 job_id INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
 job_cmd BLOB NOT NULL default '',
 job_namespace INTEGER NOT NULL,
 job_title TEXT  NOT NULL,
 job_timestamp BLOB NULL default NULL,
 job_params BLOB NOT NULL,
 job_random integer  NOT NULL default 0,
 job_attempts integer  NOT NULL default 0,
 job_token BLOB NOT NULL default '',
 job_token_timestamp BLOB NULL default NULL,
 job_sha1 BLOB NOT NULL default ''
 );
CREATE TABLE l10n_cache (
 lc_lang BLOB NOT NULL,
 lc_key TEXT NOT NULL,
 lc_value BLOB NOT NULL
 );
CREATE TABLE langlinks (
 ll_from INTEGER  NOT NULL default 0,
 ll_lang BLOB NOT NULL default '',
 ll_title TEXT  NOT NULL default ''
 );
CREATE TABLE log_search (
 ls_field BLOB NOT NULL,
 ls_value TEXT NOT NULL,
 ls_log_id INTEGER  NOT NULL default 0
 );
CREATE TABLE logging (
 log_id INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
 log_type BLOB NOT NULL default '',
 log_action BLOB NOT NULL default '',
 log_timestamp BLOB NOT NULL default '19700101000000',
 log_user INTEGER  NOT NULL default 0,
 log_user_text TEXT  NOT NULL default '',
 log_namespace INTEGER NOT NULL default 0,
 log_title TEXT  NOT NULL default '',
 log_page INTEGER  NULL,
 log_comment TEXT NOT NULL default '',
 log_params BLOB NOT NULL,
 log_deleted INTEGER  NOT NULL default 0
 );
CREATE TABLE module_deps (
 md_module BLOB NOT NULL,
 md_skin BLOB NOT NULL,
 md_deps BLOB NOT NULL
 );
CREATE TABLE msg_resource (
 mr_resource BLOB NOT NULL,
 mr_lang BLOB NOT NULL,
 mr_blob BLOB NOT NULL,
 mr_timestamp BLOB NOT NULL
 );
CREATE TABLE msg_resource_links (
 mrl_resource BLOB NOT NULL,
 mrl_message BLOB NOT NULL
 );
CREATE TABLE objectcache (
 keyname BLOB NOT NULL default '' PRIMARY KEY,
 value BLOB,
 exptime TEXT
 );
CREATE TABLE oldimage (
 oi_name TEXT  NOT NULL default '',
 oi_archive_name TEXT  NOT NULL default '',
 oi_size INTEGER  NOT NULL default 0,
 oi_width INTEGER NOT NULL default 0,
 oi_height INTEGER NOT NULL default 0,
 oi_bits INTEGER NOT NULL default 0,
 oi_description BLOB NOT NULL,
 oi_user INTEGER  NOT NULL default 0,
 oi_user_text TEXT  NOT NULL,
 oi_timestamp BLOB NOT NULL default '',
 oi_metadata BLOB NOT NULL,
 oi_media_type TEXT default NULL,
 oi_major_mime TEXT NOT NULL default "unknown",
 oi_minor_mime BLOB NOT NULL default "unknown",
 oi_deleted INTEGER  NOT NULL default 0,
 oi_sha1 BLOB NOT NULL default ''
 );
CREATE TABLE page (
 page_id INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
 page_namespace INTEGER NOT NULL,
 page_title TEXT  NOT NULL,
 page_restrictions BLOB NOT NULL,
 page_counter INTEGER  NOT NULL default 0,
 page_is_redirect INTEGER  NOT NULL default 0,
 page_is_new INTEGER  NOT NULL default 0,
 page_random real  NOT NULL,
 page_touched BLOB NOT NULL default '',
 page_links_updated BLOB NULL default NULL,
 page_latest INTEGER  NOT NULL,
 page_len INTEGER  NOT NULL,
 page_content_model BLOB DEFAULT NULL
 );
CREATE TABLE page_props (
 pp_page INTEGER NOT NULL,
 pp_propname BLOB NOT NULL,
 pp_value BLOB NOT NULL
 );
CREATE TABLE page_restrictions (
 pr_id INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
 pr_page INTEGER NOT NULL,
 pr_type BLOB NOT NULL,
 pr_level BLOB NOT NULL,
 pr_cascade INTEGER NOT NULL,
 pr_user INTEGER NULL,
 pr_expiry BLOB NULL
 );
CREATE TABLE pagelinks (
 pl_from INTEGER  NOT NULL default 0,
 pl_namespace INTEGER NOT NULL default 0,
 pl_title TEXT  NOT NULL default ''
 );
CREATE TABLE protected_titles (
 pt_namespace INTEGER NOT NULL,
 pt_title TEXT  NOT NULL,
 pt_user INTEGER  NOT NULL,
 pt_reason BLOB,
 pt_timestamp BLOB NOT NULL,
 pt_expiry BLOB NOT NULL default '',
 pt_create_perm BLOB NOT NULL
 );
CREATE TABLE querycache (
 qc_type BLOB NOT NULL,
 qc_value INTEGER  NOT NULL default 0,
 qc_namespace INTEGER NOT NULL default 0,
 qc_title TEXT  NOT NULL default ''
 );
CREATE TABLE querycache_info (
 qci_type BLOB NOT NULL default '',
 qci_timestamp BLOB NOT NULL default '19700101000000'
 );
CREATE TABLE querycachetwo (
 qcc_type BLOB NOT NULL,
 qcc_value INTEGER  NOT NULL default 0,
 qcc_namespace INTEGER NOT NULL default 0,
 qcc_title TEXT  NOT NULL default '',
 qcc_namespacetwo INTEGER NOT NULL default 0,
 qcc_titletwo TEXT  NOT NULL default ''
 );
CREATE TABLE recentchanges (
 rc_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
 rc_timestamp BLOB NOT NULL default '',
 rc_cur_time BLOB NOT NULL default '',
 rc_user INTEGER  NOT NULL default 0,
 rc_user_text TEXT  NOT NULL,
 rc_namespace INTEGER NOT NULL default 0,
 rc_title TEXT  NOT NULL default '',
 rc_comment TEXT  NOT NULL default '',
 rc_minor INTEGER  NOT NULL default 0,
 rc_bot INTEGER  NOT NULL default 0,
 rc_new INTEGER  NOT NULL default 0,
 rc_cur_id INTEGER  NOT NULL default 0,
 rc_this_oldid INTEGER  NOT NULL default 0,
 rc_last_oldid INTEGER  NOT NULL default 0,
 rc_type INTEGER  NOT NULL default 0,
 rc_source TEXT  not null default '',
 rc_patrolled INTEGER  NOT NULL default 0,
 rc_ip BLOB NOT NULL default '',
 rc_old_len INTEGER,
 rc_new_len INTEGER,
 rc_deleted INTEGER  NOT NULL default 0,
 rc_logid INTEGER  NOT NULL default 0,
 rc_log_type BLOB NULL default NULL,
 rc_log_action BLOB NULL default NULL,
 rc_params BLOB NULL
 );
CREATE TABLE redirect (
 rd_from INTEGER  NOT NULL default 0 PRIMARY KEY,
 rd_namespace INTEGER NOT NULL default 0,
 rd_title TEXT  NOT NULL default '',
 rd_interwiki TEXT default NULL,
 rd_fragment TEXT  default NULL
 );
CREATE TABLE revision (
 rev_id INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
 rev_page INTEGER  NOT NULL,
 rev_text_id INTEGER  NOT NULL,
 rev_comment BLOB NOT NULL,
 rev_user INTEGER  NOT NULL default 0,
 rev_user_text TEXT  NOT NULL default '',
 rev_timestamp BLOB NOT NULL default '',
 rev_minor_edit INTEGER  NOT NULL default 0,
 rev_deleted INTEGER  NOT NULL default 0,
 rev_len INTEGER ,
 rev_parent_id INTEGER  default NULL,
 rev_sha1 BLOB NOT NULL default '',
 rev_content_model BLOB DEFAULT NULL,
 rev_content_format BLOB DEFAULT NULL
 );
CREATE VIRTUAL TABLE searchindex USING FTS3(
 si_title,
 si_text
 );
CREATE TABLE 'searchindex_content'(docid INTEGER PRIMARY KEY, 'c0si_title', 'c1si_text');
CREATE TABLE 'searchindex_segdir'(level INTEGER,idx INTEGER,start_block INTEGER,leaves_end_block INTEGER,end_block INTEGER,root BLOB,PRIMARY KEY(level, idx));
CREATE TABLE 'searchindex_segments'(blockid INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE site_identifiers (
 si_site                    INTEGER         NOT NULL,
 si_type                    BLOB       NOT NULL,
 si_key                     BLOB       NOT NULL
 );
CREATE TABLE site_stats (
 ss_row_id INTEGER  NOT NULL,
 ss_total_views INTEGER  default 0,
 ss_total_edits INTEGER  default 0,
 ss_good_articles INTEGER  default 0,
 ss_total_pages INTEGER default '-1',
 ss_users INTEGER default '-1',
 ss_active_users INTEGER default '-1',
 ss_images INTEGER default 0
 );
CREATE TABLE sites (
 site_id                    INTEGER         NOT NULL PRIMARY KEY AUTOINCREMENT,
 site_global_key            BLOB       NOT NULL,
 site_type                  BLOB       NOT NULL,
 site_group                 BLOB       NOT NULL,
 site_source                BLOB       NOT NULL,
 site_language              BLOB       NOT NULL,
 site_protocol              BLOB       NOT NULL,
 site_domain                TEXT        NOT NULL,
 site_data                  BLOB                NOT NULL,
 site_forward              INTEGER                NOT NULL,
 site_config               BLOB                NOT NULL
 );
CREATE TABLE tag_summary (
 ts_rc_id INTEGER NULL,
 ts_log_id INTEGER NULL,
 ts_rev_id INTEGER NULL,
 ts_tags BLOB NOT NULL
 );
CREATE TABLE templatelinks (
 tl_from INTEGER  NOT NULL default 0,
 tl_namespace INTEGER NOT NULL default 0,
 tl_title TEXT  NOT NULL default ''
 );
CREATE TABLE text (
 old_id INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
 old_text BLOB NOT NULL,
 old_flags BLOB NOT NULL
 );
CREATE TABLE transcache (
 tc_url BLOB NOT NULL,
 tc_contents text,
 tc_time BLOB NOT NULL
 );
CREATE TABLE updatelog (
 ul_key TEXT NOT NULL PRIMARY KEY,
 ul_value BLOB
 );
CREATE TABLE uploadstash (
 us_id INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
 us_user INTEGER  NOT NULL,
 us_key TEXT NOT NULL,
 us_orig_path TEXT NOT NULL,
 us_path TEXT NOT NULL,
 us_source_type TEXT,
 us_timestamp BLOB NOT NULL,
 us_status TEXT NOT NULL,
 us_chunk_inx INTEGER  NULL,
 us_props BLOB,
 us_size INTEGER  NOT NULL,
 us_sha1 TEXT NOT NULL,
 us_mime TEXT,
 us_media_type TEXT default NULL,
 us_image_width INTEGER ,
 us_image_height INTEGER ,
 us_image_bits INTEGER 
 );
CREATE TABLE user (
 user_id INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
 user_name TEXT  NOT NULL default '',
 user_real_name TEXT  NOT NULL default '',
 user_password BLOB NOT NULL,
 user_newpassword BLOB NOT NULL,
 user_newpass_time BLOB,
 user_email TEXT NOT NULL,
 user_touched BLOB NOT NULL default '',
 user_token BLOB NOT NULL default '',
 user_email_authenticated BLOB,
 user_email_token BLOB,
 user_email_token_expires BLOB,
 user_registration BLOB,
 user_editcount INTEGER
 );
CREATE TABLE user_former_groups (
 ufg_user INTEGER  NOT NULL default 0,
 ufg_group BLOB NOT NULL default ''
 );
CREATE TABLE user_groups (
 ug_user INTEGER  NOT NULL default 0,
 ug_group BLOB NOT NULL default ''
 );
CREATE TABLE user_newtalk (
 user_id INTEGER NOT NULL default 0,
 user_ip BLOB NOT NULL default '',
 user_last_timestamp BLOB NULL default NULL
 );
CREATE TABLE user_properties (
 up_user INTEGER NOT NULL,
 up_property BLOB NOT NULL,
 up_value BLOB
 );
CREATE TABLE valid_tag (
 vt_tag TEXT NOT NULL PRIMARY KEY
 );
CREATE TABLE watchlist (
 wl_user INTEGER  NOT NULL,
 wl_namespace INTEGER NOT NULL default 0,
 wl_title TEXT  NOT NULL default '',
 wl_notificationtimestamp BLOB
 );
CREATE INDEX ar_revid ON archive (ar_rev_id);
CREATE INDEX ar_usertext_timestamp ON archive (ar_user_text,ar_timestamp);
CREATE INDEX cat_pages ON category (cat_pages);
CREATE UNIQUE INDEX cat_title ON category (cat_title);
CREATE UNIQUE INDEX change_tag_log_tag ON change_tag (ct_log_id,ct_tag);
CREATE UNIQUE INDEX change_tag_rc_tag ON change_tag (ct_rc_id,ct_tag);
CREATE UNIQUE INDEX change_tag_rev_tag ON change_tag (ct_rev_id,ct_tag);
CREATE INDEX change_tag_tag_id ON change_tag (ct_tag,ct_rc_id,ct_rev_id,ct_log_id);
CREATE INDEX cl_collation ON categorylinks (cl_collation);
CREATE UNIQUE INDEX cl_from ON categorylinks (cl_from,cl_to);
CREATE INDEX cl_sortkey ON categorylinks (cl_to,cl_type,cl_sortkey,cl_from);
CREATE INDEX cl_timestamp ON categorylinks (cl_to,cl_timestamp);
CREATE INDEX el_from ON externallinks (el_from, el_to);
CREATE INDEX el_index ON externallinks (el_index);
CREATE INDEX el_to ON externallinks (el_to, el_from);
CREATE INDEX exptime ON objectcache (exptime);
CREATE INDEX fa_deleted_timestamp ON filearchive (fa_deleted_timestamp);
CREATE INDEX fa_name ON filearchive (fa_name, fa_timestamp);
CREATE INDEX fa_sha1 ON filearchive (fa_sha1);
CREATE INDEX fa_storage_group ON filearchive (fa_storage_group, fa_storage_key);
CREATE INDEX fa_user_timestamp ON filearchive (fa_user_text,fa_timestamp);
CREATE UNIQUE INDEX il_from ON imagelinks (il_from,il_to);
CREATE UNIQUE INDEX il_to ON imagelinks (il_to,il_from);
CREATE INDEX img_media_mime ON image (img_media_type,img_major_mime,img_minor_mime);
CREATE INDEX img_sha1 ON image (img_sha1);
CREATE INDEX img_size ON image (img_size);
CREATE INDEX img_timestamp ON image (img_timestamp);
CREATE INDEX img_usertext_timestamp ON image (img_user_text,img_timestamp);
CREATE UNIQUE INDEX ipb_address ON ipblocks (ipb_address, ipb_user, ipb_auto, ipb_anon_only);
CREATE INDEX ipb_expiry ON ipblocks (ipb_expiry);
CREATE INDEX ipb_parent_block_id ON ipblocks (ipb_parent_block_id);
CREATE INDEX ipb_range ON ipblocks (ipb_range_start, ipb_range_end);
CREATE INDEX ipb_timestamp ON ipblocks (ipb_timestamp);
CREATE INDEX ipb_user ON ipblocks (ipb_user);
CREATE UNIQUE INDEX iw_prefix ON interwiki (iw_prefix);
CREATE UNIQUE INDEX iwl_from ON iwlinks (iwl_from, iwl_prefix, iwl_title);
CREATE INDEX iwl_prefix_from_title ON iwlinks (iwl_prefix, iwl_from, iwl_title);
CREATE INDEX iwl_prefix_title_from ON iwlinks (iwl_prefix, iwl_title, iwl_from);
CREATE INDEX job_cmd ON job (job_cmd, job_namespace, job_title, job_params);
CREATE INDEX job_cmd_token ON job (job_cmd,job_token,job_random);
CREATE INDEX job_cmd_token_id ON job (job_cmd,job_token,job_id);
CREATE INDEX job_sha1 ON job (job_sha1);
CREATE INDEX job_timestamp ON job (job_timestamp);
CREATE INDEX lc_lang_key ON l10n_cache (lc_lang, lc_key);
CREATE UNIQUE INDEX ll_from ON langlinks (ll_from, ll_lang);
CREATE INDEX ll_lang ON langlinks (ll_lang, ll_title);
CREATE INDEX log_page_id_time ON logging (log_page,log_timestamp);
CREATE INDEX log_user_text_time ON logging (log_user_text, log_timestamp);
CREATE INDEX log_user_text_type_time ON logging (log_user_text, log_type, log_timestamp);
CREATE INDEX log_user_type_time ON logging (log_user, log_type, log_timestamp);
CREATE UNIQUE INDEX ls_field_val ON log_search (ls_field,ls_value,ls_log_id);
CREATE INDEX ls_log_id ON log_search (ls_log_id);
CREATE UNIQUE INDEX md_module_skin ON module_deps (md_module, md_skin);
CREATE UNIQUE INDEX mr_resource_lang ON msg_resource (mr_resource, mr_lang);
CREATE UNIQUE INDEX mrl_message_resource ON msg_resource_links (mrl_message, mrl_resource);
CREATE UNIQUE INDEX name_title ON page (page_namespace,page_title);
CREATE INDEX name_title_timestamp ON archive (ar_namespace,ar_title,ar_timestamp);
CREATE INDEX namespace_title ON watchlist (wl_namespace, wl_title);
CREATE INDEX new_name_timestamp ON recentchanges (rc_new,rc_namespace,rc_timestamp);
CREATE INDEX oi_name_archive_name ON oldimage (oi_name,oi_archive_name);
CREATE INDEX oi_name_timestamp ON oldimage (oi_name,oi_timestamp);
CREATE INDEX oi_sha1 ON oldimage (oi_sha1);
CREATE INDEX oi_usertext_timestamp ON oldimage (oi_user_text,oi_timestamp);
CREATE INDEX page_len ON page (page_len);
CREATE INDEX page_random ON page (page_random);
CREATE INDEX page_redirect_namespace_len ON page (page_is_redirect, page_namespace, page_len);
CREATE INDEX page_time ON logging (log_namespace, log_title, log_timestamp);
CREATE INDEX page_timestamp ON revision (rev_page,rev_timestamp);
CREATE INDEX page_user_timestamp ON revision (rev_page,rev_user,rev_timestamp);
CREATE UNIQUE INDEX pl_from ON pagelinks (pl_from,pl_namespace,pl_title);
CREATE UNIQUE INDEX pl_namespace ON pagelinks (pl_namespace,pl_title,pl_from);
CREATE UNIQUE INDEX pp_page_propname ON page_props (pp_page,pp_propname);
CREATE UNIQUE INDEX pp_propname_page ON page_props (pp_propname,pp_page);
CREATE INDEX pr_cascade ON page_restrictions (pr_cascade);
CREATE INDEX pr_level ON page_restrictions (pr_level);
CREATE UNIQUE INDEX pr_pagetype ON page_restrictions (pr_page,pr_type);
CREATE INDEX pr_typelevel ON page_restrictions (pr_type,pr_level);
CREATE UNIQUE INDEX pt_namespace_title ON protected_titles (pt_namespace,pt_title);
CREATE INDEX pt_timestamp ON protected_titles (pt_timestamp);
CREATE INDEX qc_type ON querycache (qc_type,qc_value);
CREATE INDEX qcc_title ON querycachetwo (qcc_type,qcc_namespace,qcc_title);
CREATE INDEX qcc_titletwo ON querycachetwo (qcc_type,qcc_namespacetwo,qcc_titletwo);
CREATE INDEX qcc_type ON querycachetwo (qcc_type,qcc_value);
CREATE UNIQUE INDEX qci_type ON querycache_info (qci_type);
CREATE INDEX rc_cur_id ON recentchanges (rc_cur_id);
CREATE INDEX rc_ip ON recentchanges (rc_ip);
CREATE INDEX rc_namespace_title ON recentchanges (rc_namespace, rc_title);
CREATE INDEX rc_ns_usertext ON recentchanges (rc_namespace, rc_user_text);
CREATE INDEX rc_timestamp ON recentchanges (rc_timestamp);
CREATE INDEX rc_user_text ON recentchanges (rc_user_text, rc_timestamp);
CREATE INDEX rd_ns_title ON redirect (rd_namespace,rd_title,rd_from);
CREATE UNIQUE INDEX rev_page_id ON revision (rev_page, rev_id);
CREATE INDEX rev_timestamp ON revision (rev_timestamp);
CREATE INDEX site_ids_key ON site_identifiers (si_key);
CREATE INDEX site_ids_site ON site_identifiers (si_site);
CREATE UNIQUE INDEX site_ids_type ON site_identifiers (si_type, si_key);
CREATE INDEX sites_domain ON sites (site_domain);
CREATE INDEX sites_forward ON sites (site_forward);
CREATE UNIQUE INDEX sites_global_key ON sites (site_global_key);
CREATE INDEX sites_group ON sites (site_group);
CREATE INDEX sites_language ON sites (site_language);
CREATE INDEX sites_protocol ON sites (site_protocol);
CREATE INDEX sites_source ON sites (site_source);
CREATE INDEX sites_type ON sites (site_type);
CREATE UNIQUE INDEX ss_row_id ON site_stats (ss_row_id);
CREATE UNIQUE INDEX tag_summary_log_id ON tag_summary (ts_log_id);
CREATE UNIQUE INDEX tag_summary_rc_id ON tag_summary (ts_rc_id);
CREATE UNIQUE INDEX tag_summary_rev_id ON tag_summary (ts_rev_id);
CREATE UNIQUE INDEX tc_url_idx ON transcache (tc_url);
CREATE INDEX times ON logging (log_timestamp);
CREATE UNIQUE INDEX tl_from ON templatelinks (tl_from,tl_namespace,tl_title);
CREATE UNIQUE INDEX tl_namespace ON templatelinks (tl_namespace,tl_title,tl_from);
CREATE INDEX type_action ON logging (log_type, log_action, log_timestamp);
CREATE INDEX type_time ON logging (log_type, log_timestamp);
CREATE UNIQUE INDEX ufg_user_group ON user_former_groups (ufg_user,ufg_group);
CREATE INDEX ug_group ON user_groups (ug_group);
CREATE UNIQUE INDEX ug_user_group ON user_groups (ug_user,ug_group);
CREATE INDEX un_user_id ON user_newtalk (user_id);
CREATE INDEX un_user_ip ON user_newtalk (user_ip);
CREATE UNIQUE INDEX us_key ON uploadstash (us_key);
CREATE INDEX us_timestamp ON uploadstash (us_timestamp);
CREATE INDEX us_user ON uploadstash (us_user);
CREATE INDEX user_email ON user (user_email);
CREATE INDEX user_email_token ON user (user_email_token);
CREATE UNIQUE INDEX user_name ON user (user_name);
CREATE INDEX user_properties_property ON user_properties (up_property);
CREATE UNIQUE INDEX user_properties_user_property ON user_properties (up_user,up_property);
CREATE INDEX user_time ON logging (log_user, log_timestamp);
CREATE INDEX user_timestamp ON revision (rev_user,rev_timestamp);
CREATE INDEX usertext_timestamp ON revision (rev_user_text,rev_timestamp);
CREATE UNIQUE INDEX wl_user ON watchlist (wl_user, wl_namespace, wl_title);
