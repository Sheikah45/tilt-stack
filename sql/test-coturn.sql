SET FOREIGN_KEY_CHECKS=0;

DELETE FROM coturn_servers;

SET FOREIGN_KEY_CHECKS=1;

insert into coturn_servers (region, `host`, preshared_key, contact_email) values ('global', 'coturn1.faforever.com', 'key', 'test@example.com');