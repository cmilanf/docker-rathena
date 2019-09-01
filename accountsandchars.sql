USE rathena;
-- ###### PROCEDURES AND FUNCTIONS ######
DROP FUNCTION IF EXISTS getRandomSex;
DROP PROCEDURE IF EXISTS createBotAccounts;
DROP PROCEDURE IF EXISTS createBotChars;
DROP FUNCTION IF EXISTS getRandomClass;
DROP PROCEDURE IF EXISTS getRandomStats;
DROP PROCEDURE IF EXISTS getRandomLocation;
DROP PROCEDURE IF EXISTS getGmStats;
DROP PROCEDURE IF EXISTS createGmAccountsAndChars;
DROP PROCEDURE IF EXISTS createItemsForChars;
DROP PROCEDURE IF EXISTS createSkillsForChars;
DROP PROCEDURE IF EXISTS cleanDatabase;
DELIMITER //
CREATE FUNCTION getRandomSex() RETURNS ENUM('M','F','S')
BEGIN
    DECLARE sex ENUM('M','F','S') DEFAULT 'M';
    IF ROUND(RAND()) = 0 THEN SET sex = 'F';
    END IF;

    RETURN sex;
END //

CREATE PROCEDURE createBotAccounts (IN numBots INT UNSIGNED)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < numBots DO
        INSERT INTO `login` (userid,user_pass,sex,email,group_id,last_ip,character_slots,pincode)
            VALUES (CONCAT('botijo',i),'Melon.77',getRandomSex(),CONCAT('botijo',i,'@azurebootcamp.es'),0,'0.0.0.0',9,'');
        SET i = i + 1;
    END WHILE;
END //

-- CHAR creation procudere. There is a lot of cryptic values where, let's try to decypher them:
-- ###### Jobs
-- ----- Novice / 1st Class -----
--    0 Novice              1 Swordman            2 Magician            3 Archer
--    4 Acolyte              5 Merchant               6 Thief
-- ----- 2nd Class -----
--   7 Knight               8 Priest                     9 Wizard               10 Blacksmith
--  11 Hunter           12 Assassin            14 Crusader          15 Monk
--  16 Sage              17 Rogue                 18 Alchemist         19 Bard
--  20 Dancer
-- ----- Expanded Class -----
--  23 Super Novice      24 Gunslinger              25 Ninja

CREATE FUNCTION getRandomClass (sex ENUM('M','F','S')) RETURNS SMALLINT(6) UNSIGNED
BEGIN
	DECLARE class SMALLINT(6) UNSIGNED DEFAULT 0;
    
	LOOP
		SET class = FLOOR(RAND() * 25);
        IF sex = 'M' THEN
			IF class < 20 OR class > 22 THEN
				RETURN class;
			END IF;
		ELSE
			IF class != 19 AND class != 21 AND class != 22 THEN
				RETURN class;
			END IF;
		END IF;
	END LOOP;
END //

CREATE PROCEDURE getRandomStats (IN class SMALLINT(6), OUT base_level SMALLINT(6) UNSIGNED,	OUT zeny INT(11) UNSIGNED,
	OUT str SMALLINT(4) UNSIGNED, OUT agi SMALLINT(4) UNSIGNED, OUT vit SMALLINT(4) UNSIGNED, OUT `int` SMALLINT(4) UNSIGNED,
    OUT dex SMALLINT(4) UNSIGNED, OUT luk SMALLINT(4) UNSIGNED, OUT max_hp INT(11) UNSIGNED, OUT max_sp INT(11) UNSIGNED,
    OUT hair TINYINT(4) UNSIGNED, OUT hair_color SMALLINT(5) UNSIGNED, OUT clothes_color SMALLINT(5) UNSIGNED,
    OUT body SMALLINT(5) UNSIGNED, OUT weapon SMALLINT(6) UNSIGNED, OUT shield SMALLINT(6) UNSIGNED,
    OUT head_top SMALLINT(6) UNSIGNED, OUT head_mid SMALLINT(6) UNSIGNED, OUT head_bottom SMALLINT(6) UNSIGNED,
    OUT robe SMALLINT(6) UNSIGNED)
BEGIN
	-- Common parameters for every job
    SET base_level = ROUND((RAND() * (99-60))+60);
    SET zeny = ROUND((RAND() * (1000000-500))+500);
    SET hair = FLOOR(RAND() * 17);
    SET hair_color = FLOOR(RAND() * 8);
    SET clothes_color = FLOOR(RAND() * 4);
    
    -- Specific parameters depending on job class
    CASE
		-- If class is NOVICE or SUPER NOVICE, let's give him the max
		WHEN (class = 0 OR class = 23) THEN
			SET str = 999;
            SET agi = 999;
            SET vit = 999;
            SET `int` = 999;
            SET dex = 999;
            SET luk = 999;
            SET max_hp = 99999;
            SET max_sp = 99999;
		-- SWORDMAN, KNIGHT OR CRUSADER
        WHEN (class = 1 OR class = 7 OR class = 14) THEN
			SET str = ROUND((RAND() * (99-80))+80);
            SET agi = ROUND((RAND() * (99-80))+80);
            SET vit = ROUND((RAND() * (99-80))+80);
            SET `int` = ROUND((RAND() * (99-21))+21);
            SET dex = ROUND((RAND() * (99-60))+60);
            SET luk = ROUND(RAND() * 99);
            SET max_hp = ROUND((RAND() * (20000-7124))+7124);
            SET max_sp = ROUND((RAND() * (4563-983))+983);
		-- MAGICIAN, WIZARD OR SAGE
		WHEN (class = 2 OR class = 9 OR class = 16) THEN
			SET str = ROUND((RAND() * (99-11))+11);
            SET agi = ROUND((RAND() * (99-40))+40);
            SET vit = ROUND((RAND() * (99-40))+40);
            SET `int` = ROUND((RAND() * (99-90))+90);
            SET dex = ROUND((RAND() * (99-60))+60);
            SET luk = ROUND(RAND() * 99);
            SET max_hp = ROUND((RAND() * (9999-3546))+3546);
            SET max_sp = ROUND((RAND() * (9999-8129))+8129);
		-- ARCHER OR HUNTER
		WHEN (class = 3 OR class = 11) THEN
			SET str = ROUND((RAND() * (99-60))+60);
            SET agi = ROUND((RAND() * (99-80))+80);
            SET vit = ROUND((RAND() * (99-40))+40);
            SET `int` = ROUND((RAND() * (99-20))+20);
            SET dex = ROUND((RAND() * (99-90))+90);
            SET luk = ROUND(RAND() * 99);
            SET max_hp = ROUND((RAND() * (9999-4546))+4546);
            SET max_sp = ROUND((RAND() * (2454-1435))+1435);
		-- BARD
        WHEN (class = 19) THEN
			SET str = ROUND((RAND() * (99-60))+60);
            SET agi = ROUND((RAND() * (99-80))+80);
            SET vit = ROUND((RAND() * (99-40))+40);
            SET `int` = ROUND((RAND() * (99-20))+20);
            SET dex = ROUND((RAND() * (99-90))+90);
            SET luk = ROUND(RAND() * 99);
            SET max_hp = ROUND((RAND() * (9999-4546))+4546);
            SET max_sp = ROUND((RAND() * (2454-1435))+1435);
		-- DANCER
        WHEN (class = 20) THEN
			SET str = ROUND((RAND() * (99-60))+60);
            SET agi = ROUND((RAND() * (99-80))+80);
            SET vit = ROUND((RAND() * (99-40))+40);
            SET `int` = ROUND((RAND() * (99-20))+20);
            SET dex = ROUND((RAND() * (99-90))+90);
            SET luk = ROUND(RAND() * 99);
            SET max_hp = ROUND((RAND() * (9999-4546))+4546);
            SET max_sp = ROUND((RAND() * (2454-1435))+1435);
		-- ACOLYTE, PRIEST OR MONK
		WHEN (class = 4 OR class = 8 OR class = 15) THEN
			SET str = ROUND((RAND() * (99-70))+70);
            SET agi = ROUND((RAND() * (99-80))+80);
            SET vit = ROUND((RAND() * (99-60))+60);
            SET `int` = ROUND((RAND() * (99-80))+80);
            SET dex = ROUND((RAND() * (99-60))+60);
            SET luk = ROUND(RAND() * 99);
            SET max_hp = ROUND((RAND() * (9999-4546))+4546);
            SET max_sp = ROUND((RAND() * (3454-2435))+2435);
		-- MERCHANT, BLACKSMITH, ALCHEMIST, GUNSLINGER
		WHEN (class = 5 OR class = 10 OR class = 18 OR class = 24) THEN
			SET str = ROUND((RAND() * (99-90))+90);
            SET agi = ROUND((RAND() * (99-50))+50);
            SET vit = ROUND((RAND() * (99-60))+60);
            SET `int` = ROUND((RAND() * (99-50))+50);
            SET dex = ROUND((RAND() * (99-90))+90);
            SET luk = ROUND(RAND() * 99);
            SET max_hp = ROUND((RAND() * (9999-4546))+4546);
            SET max_sp = ROUND((RAND() * (2454-1435))+1435);
		-- THIEF, ASSASSIN, ROGUE, NINJA
		WHEN (class = 6 OR class = 12 OR class = 17 OR class = 25) THEN
			SET str = ROUND((RAND() * (99-50))+50);
            SET agi = ROUND((RAND() * (99-90))+90);
            SET vit = ROUND((RAND() * (99-40))+40);
            SET `int` = ROUND((RAND() * (99-40))+40);
            SET dex = ROUND((RAND() * (99-90))+90);
            SET luk = ROUND(RAND() * 99);
            SET max_hp = ROUND((RAND() * (9999-4546))+4546);
            SET max_sp = ROUND((RAND() * (2454-1435))+1435);
		ELSE BEGIN END;
	END CASE;
END //

CREATE PROCEDURE getRandomLocation (IN map_name VARCHAR(11), OUT x SMALLINT(4), OUT y SMALLINT(4))
BEGIN
    CASE
        WHEN map_name = 'aldebaran' THEN
	        SET x = ROUND((RAND() * (147-132))+132);
            SET y = ROUND((RAND() * (132-100))+100);
        WHEN map_name = 'gef_fild07' THEN
            SET x = ROUND((RAND() * (329-310))+310);
            SET y = ROUND((RAND() * (193-182))+182);
        ELSE BEGIN END;
    END CASE;
END //
	
CREATE PROCEDURE createBotChars()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE class SMALLINT(6) DEFAULT 0;
    DECLARE map_name VARCHAR(11) DEFAULT 'gef_fild07';
    DECLARE cur_account_id INT(11) UNSIGNED; 
	DECLARE cur_sex ENUM('M','F','S') DEFAULT 'F';
    DECLARE done BOOL DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT account_id,sex FROM `login` WHERE sex != 'S' AND group_id < 99;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = TRUE;
    
    OPEN cur;
    charPopulateLoop: LOOP
		FETCH cur INTO cur_account_id,cur_sex;
        IF done THEN
			CLOSE cur;
            LEAVE charPopulateLoop;
		END IF;
		SET class = getRandomClass(cur_sex);
        CALL getRandomLocation ('gef_fild07', @x, @y);
		CALL getRandomStats(class, @base_level, @zeny, @str, @agi, @vit, @`int`, @dex, @luk, @max_hp, @max_sp,
			@hair, @hair_color, @clothes_color, @body, @weapon, @shield, @head_top, @head_mid, @head_bottom, @robe);
		INSERT IGNORE INTO `char` (account_id, char_num, `name`, sex, class, base_level, job_level, base_exp, job_exp,
			zeny, str, agi, vit, `int`, dex, luk, max_hp, hp, max_sp, sp, hair, hair_color, clothes_color, body, weapon,
			shield, head_top, head_mid, head_bottom, robe, last_map, last_x, last_y, save_map, save_x, save_y)
			VALUES (cur_account_id, 1, CONCAT('botijo', i), cur_sex, class, @base_level, 50, 0, 0, @zeny, @str,
			@agi, @vit, @`int`, @dex, @luk, @max_hp, @max_hp, @max_sp, @max_sp, @hair, @hair_color, @clothes_color, 0, 0, 0,
			0, 0, 0, 0, map_name, @x, @y, map_name, @x, @y);
		SET i=i+1;
	END LOOP charPopulateLoop;
END //

CREATE PROCEDURE getGmStats (IN class SMALLINT(6), IN userid VARCHAR(16),
	OUT base_level SMALLINT(6) UNSIGNED, OUT zeny INT(11) UNSIGNED, OUT str SMALLINT(4) UNSIGNED, OUT agi SMALLINT(4) UNSIGNED,
    OUT vit SMALLINT(4) UNSIGNED, OUT `int` SMALLINT(4) UNSIGNED, OUT dex SMALLINT(4) UNSIGNED, OUT luk SMALLINT(4) UNSIGNED,
    OUT max_hp INT(11) UNSIGNED, OUT max_sp INT(11) UNSIGNED, OUT hair TINYINT(4) UNSIGNED, OUT hair_color SMALLINT(5) UNSIGNED,
    OUT clothes_color SMALLINT(5) UNSIGNED, OUT body SMALLINT(5) UNSIGNED, OUT weapon SMALLINT(6) UNSIGNED,
    OUT shield SMALLINT(6) UNSIGNED, OUT head_top SMALLINT(6) UNSIGNED, OUT head_mid SMALLINT(6) UNSIGNED,
    OUT head_bottom SMALLINT(6) UNSIGNED, OUT robe SMALLINT(6) UNSIGNED)
BEGIN
	CASE
		WHEN userid = 'Karloch' THEN
			SET base_level = 98;
			SET zeny = 1000000-500;
			SET hair = 11;
			SET hair_color = 7;
			SET clothes_color = 2;
			SET str = 999;
            SET agi = 999;
            SET vit = 999;
            SET `int` = 999;
            SET dex = 999;
            SET luk = 999;
            SET max_hp = 99999;
            SET max_sp = 99999;
		WHEN userid = 'Almarc' THEN
        	SET base_level = 98;
			SET zeny = 1000000;
			SET hair = FLOOR(RAND() * 17);
			SET hair_color = FLOOR(RAND() * 8);
			SET clothes_color = FLOOR(RAND() * 4);
			SET str = 999;
            SET agi = 999;
            SET vit = 999;
            SET `int` = 999;
            SET dex = 999;
            SET luk = 999;
            SET max_hp = 99999;
            SET max_sp = 99999;
		ELSE BEGIN END;
	END CASE;
END //

CREATE PROCEDURE createGmAccountsAndChars()
BEGIN
	DECLARE map_name VARCHAR(11) DEFAULT 'gef_fild07';
	DECLARE karloch_class SMALLINT(6) DEFAULT 9;
	DECLARE almarc_class SMALLINT(6) DEFAULT 9;
    
    CALL getRandomLocation ('gef_fild07', @x, @y);
	INSERT IGNORE INTO `login` (userid,user_pass,sex,email,group_id,last_ip,character_slots,pincode) VALUES ('Karloch','Melon.77','M','cmilanf@hispamsx.org',99,'0.0.0.0',9,'');
    SELECT account_id,userid,sex INTO @account_id,@userid,@sex FROM `login` WHERE userid='Karloch';
    CALL getGmStats(karloch_class, @userid, @base_level, @zeny, @str, @agi, @vit, @`int`, @dex, @luk, @max_hp, @max_sp,
			@hair, @hair_color, @clothes_color, @body, @weapon, @shield, @head_top, @head_mid, @head_bottom, @robe);
	INSERT IGNORE INTO `char` (account_id, char_num, `name`, sex, class, base_level, job_level, base_exp, job_exp,
		zeny, str, agi, vit, `int`, dex, luk, max_hp, hp, max_sp, sp, hair, hair_color, clothes_color, body, weapon,
		shield, head_top, head_mid, head_bottom, robe, last_map, last_x, last_y, save_map, save_x, save_y)
		VALUES (@account_id, 1, @userid, @sex, karloch_class, @base_level, 50, 0, 0, @zeny, @str,
		@agi, @vit, @`int`, @dex, @luk, @max_hp, @max_hp, @max_sp, @max_sp, @hair, @hair_color, @clothes_color, 0, 0, 0,
		0, 0, 0, 0, map_name, @x, @y, map_name, @x, @y);
    
	INSERT IGNORE INTO `login` (userid,user_pass,sex,email,group_id,last_ip,character_slots,pincode) VALUES ('Almarc','Melon.77','M','alberto.marcosg@outlook.com',99,'0.0.0.0',9,'');
    SELECT account_id,userid,sex INTO @account_id,@userid,@sex FROM `login` WHERE userid='Almarc';
    CALL getGmStats(almarc_class, @userid, @base_level, @zeny, @str, @agi, @vit, @`int`, @dex, @luk, @max_hp, @max_sp,
			@hair, @hair_color, @clothes_color, @body, @weapon, @shield, @head_top, @head_mid, @head_bottom, @robe);
	INSERT IGNORE INTO `char` (account_id, char_num, `name`, sex, class, base_level, job_level, base_exp, job_exp,
		zeny, str, agi, vit, `int`, dex, luk, max_hp, hp, max_sp, sp, hair, hair_color, clothes_color, body, weapon,
		shield, head_top, head_mid, head_bottom, robe, last_map, last_x, last_y, save_map, save_x, save_y)
		VALUES (@account_id, 1, @userid, @sex, almarc_class, @base_level, 50, 0, 0, @zeny, @str,
		@agi, @vit, @`int`, @dex, @luk, @max_hp, @max_hp, @max_sp, @max_sp, @hair, @hair_color, @clothes_color, 0, 0, 0,
		0, 0, 0, 0, map_name, @x, @y, map_name, @x, @y);
END //

CREATE PROCEDURE createItemsForChars()
BEGIN
	DECLARE cur_char_id INT(11) UNSIGNED; 
	DECLARE cur_sex ENUM('M','F','S') DEFAULT 'F';
    DECLARE cur_class SMALLINT(6) UNSIGNED;
    DECLARE head1 SMALLINT(5) UNSIGNED DEFAULT 0;
    DECLARE head2 SMALLINT(5) UNSIGNED DEFAULT 0;
    DECLARE head3 SMALLINT(5) UNSIGNED DEFAULT 0;
    DECLARE rhand SMALLINT(5) UNSIGNED DEFAULT 0;
    DECLARE lhand SMALLINT(5) UNSIGNED DEFAULT 0;
    DECLARE body SMALLINT(5) UNSIGNED DEFAULT 0;
    DECLARE robe SMALLINT(5) UNSIGNED DEFAULT 0;
    DECLARE shoes SMALLINT(5) UNSIGNED DEFAULT 0;
    DECLARE acc1 SMALLINT(5) UNSIGNED DEFAULT 0;
    DECLARE acc2 SMALLINT(5) UNSIGNED DEFAULT 0;
    DECLARE arrow SMALLINT(5) UNSIGNED DEFAULT 0;
    DECLARE done BOOL DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT char_id,class,sex FROM `char`;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = TRUE;
    
    OPEN cur;
    charPopulateItemsLoop: LOOP
		FETCH cur INTO cur_char_id,cur_class,cur_sex;
        IF done THEN
			CLOSE cur;
            LEAVE charPopulateItemsLoop;
		END IF;
        SET head1=0;
        SET head2=0;
        SET head3=0;
        SET rhand=0;
        SET lhand=0;
        SET body=0;
        SET robe=0;
        SET shoes=0;
        SET acc1=0;
        SET acc2=0;
        SET arrow=0;
        IF (cur_class != 0 AND cur_class != 23) THEN
			SET head1 = (CASE FLOOR(RAND()*17)
						WHEN 0 THEN 0
                        WHEN 1 THEN 5001
                        WHEN 2 THEN 5007
                        WHEN 3 THEN 5008
                        WHEN 4 THEN 5009
                        WHEN 5 THEN 5012
                        WHEN 6 THEN 5016
                        WHEN 7 THEN 5026
                        WHEN 8 THEN 5033
                        WHEN 9 THEN 5067
                        WHEN 10 THEN 5070
                        WHEN 11 THEN 5071
                        WHEN 12 THEN 5073
                        WHEN 13 THEN 5164
                        WHEN 14 THEN 5165
                        WHEN 15 THEN 5184
                        WHEN 16 THEN 5277
                        WHEN 17 THEN 5300
                        END);
			IF RAND() > 0.8 THEN
				SET head2 = (CASE FLOOR(RAND() * 2)
					WHEN 0 THEN 5006
					WHEN 1 THEN 2686
					END);
			ELSE
				SET head2 = 0;
			END IF;
			IF RAND() > 0.6 THEN
				SET head3 = (CASE FLOOR(RAND() * 4)
					WHEN 0 THEN 2267
                    WHEN 1 THEN 5220
                    WHEN 2 THEN 2269
                    WHEN 3 THEN 2270
                    END);
			ELSE
				SET head3 = 0;
			END IF;
            SET lhand = 2114; -- Stone Buckler
            SET body = 2369; -- Freyja Overcoat
            SET robe = 2533; -- Freyja Cape
            SET shoes = 2428; -- Freyja Boots
            SET acc1 = 2773; -- Glorious Ring 2
            SET acc2 = 2773; -- Glorious Ring 2
		END IF;
		CASE
			-- SWORDMAN, KNIGHT OR CRUSADER
			WHEN (cur_class = 1 OR cur_class = 7 OR cur_class = 14) THEN
				IF cur_class = 7 THEN
					SET lhand = 1164; -- Muramasa
                    SET rhand = 1164; -- Muramasa
				ELSE
					SET rhand = 1139; -- Tirfing
				END IF;
			-- MAGICIAN, WIZARD OR SAGE
			WHEN (cur_class = 2 OR cur_class = 9 OR cur_class = 16) THEN
				SET rhand = 1616; -- Staff of Wind
			-- ARCHER OR HUNTER
			WHEN (cur_class = 3 OR cur_class = 11) THEN
				SET rhand = 1720; -- Rudra bow
                SET lhand = 1720; -- Rudra bow
                SET arrow = 1751; -- Silver arrow
			-- BARD
			WHEN (cur_class = 19) THEN
				SET rhand = 1908; -- Guitar
			-- DANCER
			WHEN (cur_class = 20) THEN
				SET rhand = 1976; -- Queen's Whip			
			-- ACOLYTE, PRIEST OR MONK
			WHEN (cur_class = 4 OR cur_class = 8 OR cur_class = 15) THEN
				IF cur_class = 15 THEN
					SET rhand = 1882;
				ELSE
					SET rhand = 1518; -- Sword Mace
				END IF;
			-- MERCHANT, BLACKSMITH, ALCHEMIST, GUNSLINGER
			WHEN (cur_class = 5 OR cur_class = 10 OR cur_class = 18 OR cur_class = 24) THEN
				IF cur_class = 24 THEN
					SET rhand = 13161; -- Destroyer
					SET lhand = 0;
					SET arrow = 13201; -- Silver bullet                   
				ELSE
					SET rhand = 1383; -- Holy Celestial Axe
				END IF;
			-- THIEF, ASSASSIN, ROGUE, NINJA
			WHEN (cur_class = 6 OR cur_class = 12 OR cur_class = 17 OR cur_class = 25) THEN
				IF cur_class = 25 THEN
					SET rhand = 13015;
				ELSEIF cur_class = 12 THEN
					SET rhand = 1258;
				ELSE
					SET rhand = 1244;
				END IF;
			-- NOVICE, SUPER NOVICE
			WHEN (cur_class = 0 OR cur_class = 23) THEN
				SET rhand = 1148; -- Stardust blade
				SET body = 2340; -- Novice Breast
				SET shoes = 2416; -- Novice shoes
				SET lhand = 2113; -- Novice shield
				SET robe = 2510; -- Novice manteau
				SET acc1 = 2819; -- Swordman manual
				SET acc2 = 2821; -- Acolyte manual
                IF ROUND(RAND()) = 0 THEN SET head1 = 5119; -- Super novice hat
                END IF;
			ELSE BEGIN END;
		END CASE;
        IF acc1 > 0 THEN INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,acc1,1,128,1); END IF;
        IF acc2 > 0 THEN INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,acc2,1,8,1); END IF;
        IF shoes > 0 THEN INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,shoes,1,64,1); END IF;
        IF robe > 0 THEN INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,robe,1,4,1); END IF;
        IF body > 0 THEN INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,body,1,16,1); END IF;
        IF rhand = lhand THEN
			INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,rhand,1,34,1);
		ELSE
			IF rhand > 0 THEN INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,rhand,1,2,1); END IF;
			IF lhand > 0 THEN INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,lhand,1,32,1); END IF;
		END IF;
        IF head1 > 0 THEN INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,head1,1,256,1); END IF;
        IF head2 > 0 THEN INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,head2,1,512,1); END IF;
        IF head3 > 0 THEN INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,head3,1,2,1); END IF;
        IF arrow > 0 THEN INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,arrow,800,32768,1); END IF;
        INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,717,150,0,1);
		INSERT INTO inventory (char_id,nameid,amount,equip,identify) VALUES (cur_char_id,12815,50,0,1);
	END LOOP charPopulateItemsLoop;
END //

CREATE PROCEDURE createSkillsForChars()
BEGIN
	DECLARE cur_char_id INT(11) UNSIGNED; 
	DECLARE cur_sex ENUM('M','F','S') DEFAULT 'F';
    DECLARE cur_class SMALLINT(6) UNSIGNED;
    DECLARE done BOOL DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT char_id,class,sex FROM `char`;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = TRUE;
    
    OPEN cur;
    charPopulateSkillsLoop: LOOP
		FETCH cur INTO cur_char_id,cur_class,cur_sex;
        IF done THEN
			CLOSE cur;
            LEAVE charPopulateSkillsLoop;
		END IF;
        -- NOVICE and every class
        INSERT INTO skill (`char_id`, `id`, `lv`) VALUES (cur_char_id,1,9);
		CASE
			-- SUPER NOVICE
            WHEN (cur_class = 23) THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,2,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,3,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,4,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,5,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,6,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,7,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,8,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,9,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,10,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,11,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,12,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,13,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,14,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,15,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,16,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,17,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,18,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,19,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,20,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,21,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,22,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,23,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,24,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,25,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,26,2,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,27,4,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,28,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,29,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,30,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,31,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,32,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,33,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,34,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,35,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,48,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,49,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,50,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,51,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,52,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,53,1,0);
			-- SWORDMAN
            WHEN (cur_class = 1 OR cur_class = 7 OR cur_class = 14) THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,2,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,3,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,4,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,5,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,6,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,7,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,8,10,0);
			-- MAGE
            WHEN (cur_class = 2 OR cur_class = 9 OR cur_class = 16) THEN
            	INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,9,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,10,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,11,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,12,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,13,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,14,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,15,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,16,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,17,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,18,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,19,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,20,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,21,10,0);
			-- ACOLYTE
            WHEN (cur_class = 4 OR cur_class = 8 OR cur_class = 15) THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,22,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,23,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,24,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,25,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,26,2,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,27,4,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,28,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,29,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,30,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,31,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,32,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,33,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,34,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,35,1,0);
			-- MERCHANT
            WHEN (cur_class = 5 OR cur_class = 10 OR cur_class = 18) THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,36,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,37,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,38,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,39,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,40,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,41,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,42,10,0);
			-- ARCHER
            WHEN 3 OR (cur_class = 11 OR cur_class = 19 OR cur_class = 20) THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,43,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,44,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,45,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,46,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,47,10,0);
			-- THIEF
            WHEN (cur_class = 6 OR cur_class = 12 OR cur_class = 17) THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,48,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,49,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,50,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,51,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,52,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,53,1,0);
			ELSE BEGIN END;
		END CASE;
        CASE
			-- KNIGHT
            WHEN cur_class = 7 THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,55,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,56,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,57,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,58,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,59,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,60,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,61,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,62,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,63,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,64,5,0);
			-- PRIEST
            WHEN cur_class = 8 THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,54,4,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,65,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,66,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,67,3,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,68,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,69,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,70,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,71,4,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,72,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,73,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,74,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,75,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,76,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,77,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,78,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,79,10,0);
			-- WIZARD
            WHEN cur_class = 9 THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,80,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,81,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,83,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,84,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,85,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,86,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,87,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,88,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,89,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,90,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,91,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,92,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,93,1,0);	
			-- BLACKSMITH
            WHEN cur_class = 10 THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,94,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,95,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,96,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,97,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,98,3,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,99,3,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,100,3,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,101,3,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,102,3,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,103,3,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,104,3,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,105,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,106,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,107,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,108,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,109,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,110,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,111,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,112,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,113,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,114,5,0);
			-- HUNTER
            WHEN cur_class = 11 THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,115,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,116,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,117,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,118,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,119,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,120,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,121,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,122,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,123,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,124,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,125,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,126,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,127,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,128,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,129,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,130,4,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,131,5,0);
			-- ASSASIN
            WHEN cur_class = 12 THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,132,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,133,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,134,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,135,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,136,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,137,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,138,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,139,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,140,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,141,10,0);
			-- ROGUE
            WHEN cur_class = 17 THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,2,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,124,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,210,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,211,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,212,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,213,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,214,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,215,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,216,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,217,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,218,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,219,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,220,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,221,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,222,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,223,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,224,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,225,10,0);
			-- ALCHEMIST
			WHEN cur_class = 18 THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,226,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,227,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,228,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,229,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,230,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,231,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,232,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,233,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,234,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,235,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,236,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,237,5,0);
			-- CRUSHADER
            WHEN cur_class = 14 THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,22,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,23,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,28,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,35,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,55,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,63,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,64,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,248,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,249,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,250,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,251,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,252,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,253,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,254,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,255,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,256,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,257,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,258,10,0);
			-- MONK
            WHEN cur_class = 15 THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,259,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,260,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,261,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,262,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,263,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,264,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,265,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,266,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,267,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,268,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,269,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,270,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,271,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,272,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,273,5,0);
			-- SAGE
            WHEN cur_class = 16 THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,90,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,91,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,93,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,274,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,275,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,276,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,277,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,278,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,279,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,280,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,281,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,282,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,283,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,284,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,285,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,286,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,287,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,288,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,289,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,290,10,0);
			-- DANCER OR BARD
			WHEN (cur_class = 19 OR cur_class = 20) THEN
                IF cur_class = 19 THEN
					-- BARD
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,304,1,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,305,1,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,306,1,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,307,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,308,1,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,309,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,310,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,311,1,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,312,1,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,313,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,315,10,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,316,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,317,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,318,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,319,10,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,320,10,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,321,10,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,322,10,0);
				ELSEIF cur_class = 20 THEN
					-- DANCER
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,304,1,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,305,1,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,306,1,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,307,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,308,1,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,309,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,310,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,311,1,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,312,1,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,313,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,323,10,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,324,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,325,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,326,5,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,327,10,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,328,10,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,329,10,0);
					INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,330,10,0);
				END IF;
			-- GUNSLINGER
			WHEN cur_class = 24 THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,500,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,501,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,502,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,503,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,504,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,505,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,506,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,507,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,508,1,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,509,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,510,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,511,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,512,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,513,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,514,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,515,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,516,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,517,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,518,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,519,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,520,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,521,10,0);
			-- NINJA
            WHEN cur_class = 25 THEN
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,522,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,523,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,524,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,525,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,526,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,527,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,528,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,529,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,530,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,531,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,532,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,533,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,534,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,535,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,536,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,537,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,538,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,539,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,540,10,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,541,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,542,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,543,5,0);
				INSERT INTO `skill` (`char_id`,`id`,`lv`,`flag`) VALUES (cur_char_id,544,10,0);
			ELSE BEGIN END;
		END CASE;
	END LOOP charPopulateSkillsLoop;
END //

CREATE PROCEDURE cleanDatabase()
BEGIN
    DELETE FROM inventory;
    DELETE FROM skill;
    DELETE FROM `char`;
    DELETE FROM `login` WHERE account_id != 1;
END //

CREATE PROCEDURE createCustomCharOnlineLockTable()
BEGIN
	CREATE TABLE custom_char_online_lock (
    	`name` varchar(30) NOT NULL DEFAULT '',
    	`online` tinyint(2) NOT NULL default '0'
	) ENGINE=MyISAM;

	INSERT INTO custom_char_online_lock (`name`)
	SELECT `name`
	FROM `char`
	WHERE `name` LIKE 'botijo%';
END //

-- ###### ACCOUNTS ######
CALL cleanDatabase();
CALL createGmAccountsAndChars();
CALL createBotAccounts(5000);
CALL createBotChars();
CALL createItemsForChars();
CALL createSkillsForChars();
CALL createCustomCharOnlineLockTable();
SET GLOBAL max_connections = 2048;
SET GLOBAL event_scheduler = ON;

CREATE EVENT online_status_sync
ON SCHEDULE EVERY 5 MINUTE
STARTS CURRENT_TIMESTAMP + INTERVAL 5 MINUTE
COMMENT 'Online char status sync to custom_char_online_lock table'
DO
	UPDATE `char` src, custom_char_online_lock dst
	SET dst.online = src.online
	WHERE src.name = dst.name;
