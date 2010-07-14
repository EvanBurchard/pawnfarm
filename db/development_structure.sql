CREATE TABLE `executions` (
  `id` int(11) NOT NULL auto_increment,
  `scheme_id` int(11) default NULL,
  `pawn_id` int(11) default NULL,
  `state` varchar(255) collate utf8_unicode_ci default NULL,
  `candidate_a` varchar(255) collate utf8_unicode_ci default NULL,
  `candidate_b` varchar(255) collate utf8_unicode_ci default NULL,
  `winner` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `pawns` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `description` varchar(255) collate utf8_unicode_ci default NULL,
  `twitter_username` varchar(255) collate utf8_unicode_ci NOT NULL,
  `twitter_password` varchar(255) collate utf8_unicode_ci NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `active` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `pawns_schemes` (
  `pawn_id` int(11) NOT NULL,
  `scheme_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) collate utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schemes` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `title` varchar(255) collate utf8_unicode_ci NOT NULL,
  `description` varchar(255) collate utf8_unicode_ci default NULL,
  `type` varchar(255) collate utf8_unicode_ci default NULL,
  `random_interval` tinyint(1) default NULL,
  `frequency` int(11) default NULL,
  `tweet_prompt` varchar(255) collate utf8_unicode_ci default NULL,
  `tweet_prompt_relationship` varchar(255) collate utf8_unicode_ci default NULL,
  `prompt` varchar(255) collate utf8_unicode_ci default NULL,
  `target` varchar(255) collate utf8_unicode_ci default NULL,
  `target_relationship` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `turk_forms` (
  `id` int(11) NOT NULL auto_increment,
  `url` varchar(255) collate utf8_unicode_ci default NULL,
  `execution_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `body` text collate utf8_unicode_ci,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `twitter_accounts` (
  `id` int(11) NOT NULL auto_increment,
  `friends` varchar(255) collate utf8_unicode_ci default NULL,
  `followers` varchar(255) collate utf8_unicode_ci default NULL,
  `friend_count` int(11) default NULL,
  `follower_count` int(11) default NULL,
  `last_tweeted` datetime default NULL,
  `status` varchar(255) collate utf8_unicode_ci default NULL,
  `pawn_id` int(11) default NULL,
  `username` varchar(255) collate utf8_unicode_ci default NULL,
  `password` varchar(255) collate utf8_unicode_ci default NULL,
  `access_key` varchar(255) collate utf8_unicode_ci default NULL,
  `access_secret` varchar(255) collate utf8_unicode_ci default NULL,
  `request_token` varchar(255) collate utf8_unicode_ci default NULL,
  `request_secret` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) collate utf8_unicode_ci NOT NULL,
  `email` varchar(255) collate utf8_unicode_ci NOT NULL,
  `crypted_password` varchar(255) collate utf8_unicode_ci NOT NULL,
  `password_salt` varchar(255) collate utf8_unicode_ci NOT NULL,
  `persistence_token` varchar(255) collate utf8_unicode_ci NOT NULL,
  `single_access_token` varchar(255) collate utf8_unicode_ci NOT NULL,
  `perishable_token` varchar(255) collate utf8_unicode_ci NOT NULL,
  `login_count` int(11) NOT NULL default '0',
  `failed_login_count` int(11) NOT NULL default '0',
  `last_request_at` datetime default NULL,
  `current_login_at` datetime default NULL,
  `last_login_at` datetime default NULL,
  `current_login_ip` varchar(255) collate utf8_unicode_ci default NULL,
  `last_login_ip` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20100629150411');

INSERT INTO schema_migrations (version) VALUES ('20100630033709');

INSERT INTO schema_migrations (version) VALUES ('20100630040319');

INSERT INTO schema_migrations (version) VALUES ('20100630194513');

INSERT INTO schema_migrations (version) VALUES ('20100703172056');

INSERT INTO schema_migrations (version) VALUES ('20100706063849');

INSERT INTO schema_migrations (version) VALUES ('20100712032747');

INSERT INTO schema_migrations (version) VALUES ('20100713063346');

INSERT INTO schema_migrations (version) VALUES ('20100713172338');