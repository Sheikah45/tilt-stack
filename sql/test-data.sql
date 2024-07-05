SET FOREIGN_KEY_CHECKS=0;

DELETE FROM service_links;
DELETE FROM player_events;
DELETE FROM reported_user;
DELETE FROM moderation_report;
DELETE FROM teamkills;
DELETE FROM unique_id_users;
DELETE FROM uniqueid;
DELETE FROM uniqueid_exempt;
DELETE FROM friends_and_foes;
DELETE FROM tutorial;
DELETE FROM map_version_review;
DELETE FROM map_version_reviews_summary;
DELETE FROM map_version;
DELETE FROM `map`;
DELETE FROM coop_map;
DELETE FROM mod_version_review;
DELETE FROM mod_version_reviews_summary;
DELETE FROM mod_version;
DELETE FROM `mod`;
DELETE FROM mod_stats;
DELETE FROM updates_faf;
DELETE FROM updates_faf_files;
DELETE FROM avatars;
DELETE FROM avatars_list;
DELETE FROM ban;
DELETE FROM clan_membership;
DELETE FROM clan;
DELETE FROM game_player_stats;
DELETE FROM game_review;
DELETE FROM game_reviews_summary;
DELETE FROM game_stats;
DELETE FROM game_featuredMods;
DELETE FROM name_history;
DELETE FROM user_group_assignment;
DELETE FROM user_group;
DELETE FROM login;
DELETE FROM email_domain_blacklist;
DELETE FROM leaderboard;
DELETE FROM matchmaker_queue;
DELETE FROM matchmaker_queue_map_pool;
DELETE FROM map_pool;
DELETE FROM map_pool_map_version;

SET FOREIGN_KEY_CHECKS=1;

-- Login table
-- Most accounts get a creation time in the past so that they pass account
-- age check.
insert into login (id, login, email, password, create_time) values (1, 'test', 'test@example.com', SHA2('test', 256), '2000-01-01 00:00:00');

-- Service links
INSERT INTO `service_links` VALUES ('e8e4edd5-af12-11ed-b20e-0242c0a8a002',1,'STEAM','111111',0,1);

-- User groups
INSERT INTO user_group (id, technical_name, parent_group_id, public, name_key) VALUES (1, 'faf_organisation', null, 1, 'user_group.faf.organisation');
INSERT INTO user_group (id, technical_name, parent_group_id, public, name_key) VALUES (2, 'faf_councilor_administration', 1, 1, 'user_group.faf.councilor.administration');
INSERT INTO user_group (id, technical_name, parent_group_id, public, name_key) VALUES (3, 'faf_councilor_balance', 1, 1, 'user_group.faf.councilor.balance');
INSERT INTO user_group (id, technical_name, parent_group_id, public, name_key) VALUES (4, 'faf_councilor_devops', 1, 1, 'user_group.faf.councilor.devops');
INSERT INTO user_group (id, technical_name, parent_group_id, public, name_key) VALUES (5, 'faf_councilor_game', 1, 1, 'user_group.faf.councilor.game');
INSERT INTO user_group (id, technical_name, parent_group_id, public, name_key) VALUES (6, 'faf_councilor_maps_mods', 1, 1, 'user_group.faf.councilor.maps_mods');
INSERT INTO user_group (id, technical_name, parent_group_id, public, name_key) VALUES (7, 'faf_councilor_moderation', 1, 1, 'user_group.faf.councilor.moderation');
INSERT INTO user_group (id, technical_name, parent_group_id, public, name_key) VALUES (8, 'faf_councilor_player', 1, 1, 'user_group.faf.councilor.player');
INSERT INTO user_group (id, technical_name, parent_group_id, public, name_key) VALUES (9, 'faf_councilor_promotion', 1, 1, 'user_group.faf.councilor.promotion');
INSERT INTO user_group (id, technical_name, parent_group_id, public, name_key) VALUES (10, 'faf_balance_team', 3, 1, 'user_group.faf.balance_team');
INSERT INTO user_group (id, technical_name, parent_group_id, public, name_key) VALUES (11, 'faf_server_administrators', 4, 1, 'user_group.faf.server_administrators');
INSERT INTO user_group (id, technical_name, parent_group_id, public, name_key) VALUES (28, 'faf_moderators_global', 7, 1, 'user_group.faf.moderators.global');

-- Permissions
insert into user_group_assignment(user_id, group_id)  values (1, (SELECT id from user_group WHERE technical_name = 'faf_server_administrators'));
insert into user_group_assignment(user_id, group_id)  values (1, (SELECT id from user_group WHERE technical_name = 'faf_moderators_global'));


-- UniqueID_exempt
insert into uniqueid_exempt (user_id, reason) values (1, 'Because test');

-- UID Samples
INSERT INTO `uniqueid` (`hash`, `uuid`, `mem_SerialNumber`, `deviceID`, `manufacturer`, `name`, `processorId`, `SMBIOSBIOSVersion`, `serialNumber`, `volumeSerialNumber`)
VALUES ('some_id', '-', '-', '-', '-', '-', '-', '-', '-', '-'),
       ('another_id', '-', '-', '-', '-', '-', '-', '-', '-', '-');

-- Sample maps
insert into map (id, display_name, map_type, battle_type, author, license)
values
(1, 'SCMP_001', 'FFA', 'skirmish', 1, 1),
(2, 'SCMP_002', 'FFA', 'skirmish', 1, 1),
(3, 'SCMP_003', 'FFA', 'skirmish', 1, 1),
(4, 'SCMP_004', 'FFA', 'skirmish', 1, 1),
(5, 'SCMP_005', 'FFA', 'skirmish', 1, 1),
(6, 'SCMP_006', 'FFA', 'skirmish', 1, 1),
(7, 'SCMP_007', 'FFA', 'skirmish', 1, 1),
(8, 'SCMP_008', 'FFA', 'skirmish', 1, 1),
(9, 'SCMP_009', 'FFA', 'skirmish', 1, 1),
(10, 'SCMP_010', 'FFA', 'skirmish', 1, 1),
(11, 'SCMP_011', 'FFA', 'skirmish', 1, 1),
(12, 'SCMP_012', 'FFA', 'skirmish', 1, 1),
(13, 'SCMP_013', 'FFA', 'skirmish', 1, 1),
(14, 'SCMP_014', 'FFA', 'skirmish', 1, 1),
(15, 'SCMP_015', 'FFA', 'skirmish', 1, 1);

insert into map_version (id, description, max_players, width, height, version, filename, hidden, map_id)
values
(1, 'SCMP 001', 8, 1024, 1024, 1, 'maps/scmp_001.zip', 0, 1),
(2, 'SCMP 002', 8, 1024, 1024, 1, 'maps/scmp_002.zip', 0, 2),
(3, 'SCMP 003', 8, 1024, 1024, 1, 'maps/scmp_003.zip', 0, 3),
(4, 'SCMP 004', 8, 1024, 1024, 1, 'maps/scmp_004.zip', 0, 4),
(5, 'SCMP 005', 8, 2048, 2048, 1, 'maps/scmp_005.zip', 0, 5),
(6, 'SCMP 006', 8, 1024, 1024, 1, 'maps/scmp_006.zip', 0, 6),
(7, 'SCMP 007', 8, 512, 512, 1, 'maps/scmp_007.zip', 0, 7),
(8, 'SCMP 008', 8, 1024, 1024, 1, 'maps/scmp_008.zip', 0, 8),
(9, 'SCMP 009', 8, 1024, 1024, 1, 'maps/scmp_009.zip', 0, 9),
(10, 'SCMP 010', 8, 1024, 1024, 1, 'maps/scmp_010.zip', 0, 10),
(11, 'SCMP 011', 8, 2048, 2048, 1, 'maps/scmp_011.zip', 0, 11),
(12, 'SCMP 012', 8, 256, 256, 1, 'maps/scmp_012.zip', 0, 12),
(13, 'SCMP 013', 8, 256, 256, 1, 'maps/scmp_013.zip', 0, 13),
(14, 'SCMP 014', 8, 1024, 1024, 1, 'maps/scmp_014.zip', 0, 14),
(15, 'SCMP 015', 8, 512, 512, 1, 'maps/scmp_015.zip', 0, 15),
(16, 'SCMP 015', 8, 512, 512, 2, 'maps/scmp_015.v0002.zip', 0, 15),
(17, 'SCMP 015', 8, 512, 512, 3, 'maps/scmp_015.v0003.zip', 0, 15);

INSERT INTO `coop_map` (`type`, `name`, `description`, `version`, `filename`)
VALUES (0, 'FA Campaign map', 'A map from the FA campaign', 2, 'maps/scmp_coop_123.v0002.zip'),
       (1, 'Aeon Campaign map', 'A map from the Aeon campaign', 0, 'maps/scmp_coop_124.v0000.zip'),
       (2, 'Cybran Campaign map', 'A map from the Cybran campaign', 1, 'maps/scmp_coop_125.v0001.zip'),
       (3, 'UEF Campaign map',   'A map from the UEF campaign', 99, 'maps/scmp_coop_126.v0099.zip'),
       (4, 'Prothyon - 16', 'Prothyon - 16 is a secret UEF facility...', 5, 'maps/prothyon16.v0005.zip'),
       (100, 'Corrupted Map', 'This is corrupted and you should never see it', 0, '$invalid &string*');

insert into game_featuredMods (id, gamemod, name, description, publish, git_url, git_branch, file_extension, allow_override)
values (1, 'faf', 'FAF', 'Forged Alliance Forever', 1, 'https://github.com/FAForever/fa.git', 'deploy/faf', 'nx2', FALSE);

insert into game_stats (id, startTime, gameName, gameType, gameMod, `host`, mapId, validity)
values (1, NOW(), 'Test game', '0', 1, 1, 1, 0);

insert into leaderboard (id, technical_name, name_key, description_key)
values (1, "global", "leaderboard.global.name", "leaderboard.global.desc"),
       (2, "ladder1v1", "leaderboard.ladder1v1.name", "leaderboard.ladder1v1.desc"),
       (3, "ladder2v2", "leaderboard.ladder2v2.name", "leaderboard.ladder2v2.desc");

insert into matchmaker_queue (id, technical_name, featured_mod_id, leaderboard_id, name_key)
values (1, "ladder1v1", 1, 1, "matchmaker.ladder1v1"),
       (2, "ladder2v2", 1, 2, "matchmaker.ladder2v2");

insert into map_pool (id, name)
values (1, "Ladder1v1 season 1: 5-10k"),
       (2, "Ladder1v1 season 1: all"),
       (3, "Large maps"),
       (4, "2v2 maps");

insert into map_pool_map_version (map_pool_id, map_version_id)
values (1, 15), (1, 16), (1, 17),
       (2, 11), (2, 14), (2, 15), (2, 16), (2, 17),
       (3, 1),  (3, 2),  (3, 3), (4, 1);

insert into matchmaker_queue_map_pool (matchmaker_queue_id, map_pool_id, min_rating, max_rating)
values (1, 1, NULL, 800),
       (1, 2, 800, NULL),
       (1, 3, 1000, NULL),
       (2, 4, NULL, NULL);

insert into `mod` (id, display_name, author, license)
VALUES (1, 'test-mod', 'baz', 1),
       (2, 'test-mod2', 'baz', 1),
       (3, 'test-mod3', 'baz', 1);

insert into mod_version (id, mod_id, uid, version, description, type, filename, icon) VALUES
        (1, 1, 'foo', 1, '', 'UI', 'foobar.zip', 'foobar.png'),
        (2, 1, 'bar', 2, '', 'SIM', 'foobar2.zip', 'foobar.png'),
        (3, 2, 'baz', 1, '', 'UI', 'foobar3.zip', 'foobar3.png'),
        (4, 3, 'EA040F8E-857A-4566-9879-0D37420A5B9D', 1, '', 'SIM', 'foobar4.zip', 'foobar4.png');

insert into mod_stats (mod_id, times_played, likers) VALUES
        (1, 0, ''),
        (2, 0, ''),
        (3, 1, '');

-- sample avatars
insert into avatars_list (id, filename, tooltip) values
  (1, 'qai2.png', 'QAI'),
  (2, 'UEF.png', 'UEF');

insert into avatars (idUser, idAvatar, selected) values (1, 1, 0), (1, 2, 1);

insert into updates_faf (id, filename, path) values
    (1, 'ForgedAlliance.exe', 'bin'),
    (11, 'effects.nx2', 'gamedata'),
    (12, 'env.nx2', 'gamedata');

insert into updates_faf_files (id, fileId, version, name, md5, obselete) values
    (711, 1, 3658, 'ForgedAlliance.3658.exe', '2cd7784fb131ea4955e992cfee8ca9b8', 0),
    (745, 1, 3659, 'ForgedAlliance.3659.exe', 'ee2df6c3cb80dc8258428e8fa092bce1', 0),
    (723, 11, 3658, 'effects_0.3658.nxt', '3758baad77531dd5323c766433412e91', 0),
    (734, 11, 3659, 'effects_0.3659.nxt', '3758baad77531dd5323c766433412e91', 0),
    (680, 12, 3656, 'env_0.3656.nxt', '32a50729cb5155ec679771f38a151d29', 0);