DROP TABLE IF EXISTS APPM_PLATFORM;
DROP SEQUENCE IF EXISTS APPM_PLATFORM_PK_SEQ;
CREATE SEQUENCE APPM_PLATFORM_PK_SEQ;

CREATE TABLE APPM_PLATFORM (
ID INT DEFAULT NEXTVAL('APPM_PLATFORM_PK_SEQ') UNIQUE,
IDENTIFIER VARCHAR (100) NOT NULL,
TENANT_ID INT NOT NULL ,
NAME VARCHAR (255),
FILE_BASED BOOLEAN,
DESCRIPTION VARCHAR(2048),
IS_SHARED BOOLEAN,
IS_DEFAULT_TENANT_MAPPING BOOLEAN,
ICON_NAME VARCHAR (100),
PRIMARY KEY (IDENTIFIER, TENANT_ID)
);

DROP TABLE IF EXISTS APPM_PLATFORM_PROPERTIES;
DROP SEQUENCE IF EXISTS APPM_PLATFORM_PROPERTIES_PK_SEQ;
CREATE SEQUENCE APPM_PLATFORM_PROPERTIES_PK_SEQ;

CREATE TABLE APPM_PLATFORM_PROPERTIES (
ID INT DEFAULT NEXTVAL('APPM_PLATFORM_PROPERTIES_PK_SEQ'),
PLATFORM_ID INT NOT NULL,
PROP_NAME VARCHAR (100) NOT NULL,
OPTIONAL BOOLEAN,
DEFAUL_VALUE VARCHAR (255),
FOREIGN KEY(PLATFORM_ID) REFERENCES APPM_PLATFORM(ID) ON DELETE CASCADE,
PRIMARY KEY (ID, PLATFORM_ID, PROP_NAME)
);

DROP TABLE IF EXISTS APPM_PLATFORM_TENANT_MAPPING;
DROP SEQUENCE IF EXISTS APPM_PLATFORM_TENANT_MAPPING_PK_SEQ;
CREATE SEQUENCE APPM_PLATFORM_TENANT_MAPPING_PK_SEQ;

CREATE TABLE APPM_PLATFORM_TENANT_MAPPING (
ID INT DEFAULT NEXTVAL('APPM_PLATFORM_TENANT_MAPPING_PK_SEQ'),
TENANT_ID INT NOT NULL ,
PLATFORM_ID INT NOT NULL,
FOREIGN KEY(PLATFORM_ID) REFERENCES APPM_PLATFORM(ID) ON DELETE CASCADE,
PRIMARY KEY (ID, TENANT_ID, PLATFORM_ID)
);

CREATE INDEX FK_PLATFROM_TENANT_MAPPING_PLATFORM ON APPM_PLATFORM_TENANT_MAPPING(PLATFORM_ID ASC);

DROP TABLE IF EXISTS APPM_APPLICATION_CATEGORY;
DROP SEQUENCE IF EXISTS APPM_APPLICATION_CATEGORY_PK_SEQ;
CREATE SEQUENCE APPM_APPLICATION_CATEGORY_PK_SEQ;

CREATE TABLE IF NOT EXISTS APPM_APPLICATION_CATEGORY (
  ID INT DEFAULT NEXTVAL('APPM_APPLICATION_CATEGORY_PK_SEQ'),
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION TEXT NULL,
  PUBLISHED BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (ID));

INSERT INTO APPM_APPLICATION_CATEGORY (NAME, DESCRIPTION, PUBLISHED) VALUES ('Enterprise', 'Enterprise level
applications which the artifacts need to be provided', TRUE);
INSERT INTO APPM_APPLICATION_CATEGORY (NAME, DESCRIPTION, PUBLISHED) VALUES ('Public', 'Public category in which the
application need to be downloaded from the public application store', TRUE);

DROP TABLE IF EXISTS APPM_LIFECYCLE_STATE;
DROP SEQUENCE IF EXISTS APPM_LIFECYCLE_STATE_PK_SEQ;
CREATE SEQUENCE APPM_LIFECYCLE_STATE_PK_SEQ;

-- -----------------------------------------------------
-- Table APPM_LIFECYCLE_STATE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS APPM_LIFECYCLE_STATE (
  ID INT DEFAULT NEXTVAL('APPM_LIFECYCLE_STATE_PK_SEQ'),
  NAME VARCHAR(100) NOT NULL,
  IDENTIFIER VARCHAR(100) NOT NULL,
  DESCRIPTION TEXT NULL,
  PRIMARY KEY (ID));

DROP INDEX IF EXISTS APPM_LIFECYCLE_STATE_IDENTIFIER_UNIQUE;
CREATE INDEX APPM_LIFECYCLE_STATE_IDENTIFIER_UNIQUE ON APPM_LIFECYCLE_STATE(IDENTIFIER ASC);

INSERT INTO APPM_LIFECYCLE_STATE (NAME, IDENTIFIER, DESCRIPTION) VALUES ('CREATED', 'CREATED', 'Application creation
initial state');
INSERT INTO APPM_LIFECYCLE_STATE (NAME, IDENTIFIER, DESCRIPTION)
VALUES ('IN REVIEW', 'IN REVIEW', 'Application is in in-review state');
INSERT INTO APPM_LIFECYCLE_STATE (NAME, IDENTIFIER, DESCRIPTION)
VALUES ('APPROVED', 'APPROVED', 'State in which Application is approved after reviewing.');
INSERT INTO APPM_LIFECYCLE_STATE (NAME, IDENTIFIER, DESCRIPTION)
VALUES ('REJECTED', 'REJECTED', 'State in which Application is rejected after reviewing.');
INSERT INTO APPM_LIFECYCLE_STATE (NAME, IDENTIFIER, DESCRIPTION)
VALUES ('PUBLISHED', 'PUBLISHED', 'State in which Application is in published state.');
INSERT INTO APPM_LIFECYCLE_STATE (NAME, IDENTIFIER, DESCRIPTION)
VALUES ('UNPUBLISHED', 'UNPUBLISHED', 'State in which Application is in un published state.');
INSERT INTO APPM_LIFECYCLE_STATE (NAME, IDENTIFIER, DESCRIPTION)
VALUES ('RETIRED', 'RETIRED', 'Retiring an application to indicate end of life state,');

DROP TABLE IF EXISTS APPM_LIFECYCLE_STATE_TRANSITION;
DROP SEQUENCE IF EXISTS APPM_LIFECYCLE_STATE_TRANSITION_PK_SEQ;
CREATE SEQUENCE APPM_LIFECYCLE_STATE_TRANSITION_PK_SEQ;

CREATE TABLE IF NOT EXISTS APPM_LIFECYCLE_STATE_TRANSITION
(
  ID INT DEFAULT NEXTVAL('APPM_LIFECYCLE_STATE_TRANSITION_PK_SEQ'),
  INITIAL_STATE INT,
  NEXT_STATE INT,
  PERMISSION VARCHAR(1024),
  DESCRIPTION VARCHAR(2048),
  PRIMARY KEY (INITIAL_STATE, NEXT_STATE),
  FOREIGN KEY (INITIAL_STATE) REFERENCES APPM_LIFECYCLE_STATE(ID) ON DELETE CASCADE,
  FOREIGN KEY (NEXT_STATE) REFERENCES APPM_LIFECYCLE_STATE(ID) ON DELETE CASCADE
);

INSERT INTO APPM_LIFECYCLE_STATE_TRANSITION(INITIAL_STATE, NEXT_STATE, PERMISSION, DESCRIPTION) VALUES
  (1, 2, null, 'Submit for review');
INSERT INTO APPM_LIFECYCLE_STATE_TRANSITION(INITIAL_STATE, NEXT_STATE, PERMISSION, DESCRIPTION) VALUES
  (2, 1, null, 'Revoke from review');
INSERT INTO APPM_LIFECYCLE_STATE_TRANSITION(INITIAL_STATE, NEXT_STATE, PERMISSION, DESCRIPTION) VALUES
  (2, 3, '/permission/admin/manage/device-mgt/application/review', 'APPROVE');
INSERT INTO APPM_LIFECYCLE_STATE_TRANSITION(INITIAL_STATE, NEXT_STATE, PERMISSION, DESCRIPTION) VALUES
  (2, 4, '/permission/admin/manage/device-mgt/application/review', 'REJECT');
INSERT INTO APPM_LIFECYCLE_STATE_TRANSITION(INITIAL_STATE, NEXT_STATE, PERMISSION, DESCRIPTION) VALUES
  (3, 4, '/permission/admin/manage/device-mgt/application/review', 'REJECT');
INSERT INTO APPM_LIFECYCLE_STATE_TRANSITION(INITIAL_STATE, NEXT_STATE, PERMISSION, DESCRIPTION) VALUES
  (3, 5, null, 'PUBLISH');
INSERT INTO APPM_LIFECYCLE_STATE_TRANSITION(INITIAL_STATE, NEXT_STATE, PERMISSION, DESCRIPTION) VALUES
  (5, 6, null, 'UN PUBLISH');
INSERT INTO APPM_LIFECYCLE_STATE_TRANSITION(INITIAL_STATE, NEXT_STATE, PERMISSION, DESCRIPTION) VALUES
  (6, 5, null, 'PUBLISH');
INSERT INTO APPM_LIFECYCLE_STATE_TRANSITION(INITIAL_STATE, NEXT_STATE, PERMISSION, DESCRIPTION) VALUES
  (4, 1, null, 'Return to CREATE STATE');
INSERT INTO APPM_LIFECYCLE_STATE_TRANSITION(INITIAL_STATE, NEXT_STATE, PERMISSION, DESCRIPTION) VALUES
  (6, 1, null, 'Return to CREATE STATE');
INSERT INTO APPM_LIFECYCLE_STATE_TRANSITION(INITIAL_STATE, NEXT_STATE, PERMISSION, DESCRIPTION) VALUES
  (6, 7, null, 'Retire');


DROP TABLE IF EXISTS APPM_APPLICATION;
DROP SEQUENCE IF EXISTS APPM_APPLICATION_PK_SEQ;
CREATE SEQUENCE APPM_APPLICATION_PK_SEQ;

CREATE TABLE IF NOT EXISTS APPM_APPLICATION (
  ID INT DEFAULT NEXTVAL('APPM_APPLICATION_PK_SEQ') UNIQUE,
  UUID VARCHAR(100) NOT NULL,
  IDENTIFIER VARCHAR(255) NULL,
  NAME VARCHAR(100) NOT NULL,
  SHORT_DESCRIPTION VARCHAR(255) NULL,
  DESCRIPTION TEXT NULL,
  SCREEN_SHOT_COUNT INT DEFAULT 0,
  VIDEO_NAME VARCHAR(100) NULL,
  CREATED_BY VARCHAR(255) NULL,
  CREATED_AT TIMESTAMP NOT NULL,
  MODIFIED_AT TIMESTAMP NULL,
  IS_FREE BOOLEAN DEFAULT TRUE,
  PAYMENT_CURRENCY VARCHAR(45) NULL,
  PAYMENT_PRICE DECIMAL(10,2) NULL,
  APPLICATION_CATEGORY_ID INT NOT NULL,
  LIFECYCLE_STATE_ID INT NOT NULL,
  LIFECYCLE_STATE_MODIFIED_BY VARCHAR(255) NULL,
  LIFECYCLE_STATE_MODIFIED_AT TIMESTAMP NULL,
  TENANT_ID INT NOT NULL,
  PLATFORM_ID INT NOT NULL,
  PRIMARY KEY (ID, APPLICATION_CATEGORY_ID, LIFECYCLE_STATE_ID, PLATFORM_ID),
  FOREIGN KEY (APPLICATION_CATEGORY_ID)
  REFERENCES APPM_APPLICATION_CATEGORY (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_APPM_APPLICATION_APPM_LIFECYCLE_STATE1
  FOREIGN KEY (LIFECYCLE_STATE_ID)
  REFERENCES APPM_LIFECYCLE_STATE (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_APPM_APPLICATION_APPM_PLATFORM1
  FOREIGN KEY (PLATFORM_ID)
  REFERENCES APPM_PLATFORM (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX IF NOT EXISTS FK_APPLICATION_APPLICATION_CATEGORY ON APPM_APPLICATION(APPLICATION_CATEGORY_ID ASC);
CREATE INDEX IF NOT EXISTS UK_APPLICATION_UUID ON APPM_APPLICATION(UUID ASC);

DROP TABLE IF EXISTS APPM_APPLICATION_PROPERTY;
-- -----------------------------------------------------
-- Table APPM_APPLICATION_PROPERTY
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS APPM_APPLICATION_PROPERTY (
  PROP_KEY VARCHAR(255) NOT NULL,
  PROP_VAL TEXT NULL,
  APPLICATION_ID INT NOT NULL,
  PRIMARY KEY (PROP_KEY, APPLICATION_ID),
  CONSTRAINT FK_APPLICATION_PROPERTY_APPLICATION
    FOREIGN KEY (APPLICATION_ID)
    REFERENCES APPM_APPLICATION (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX FK_APPLICATION_PROPERTY_APPLICATION ON APPM_APPLICATION_PROPERTY(APPLICATION_ID ASC);

CREATE TABLE IF NOT EXISTS APPM_APPLICATION_TAG (
  NAME VARCHAR(45) NOT NULL,
  APPLICATION_ID INT NOT NULL,
  PRIMARY KEY (APPLICATION_ID, NAME),
  CONSTRAINT fk_APPM_APPLICATION_TAG_APPM_APPLICATION1
  FOREIGN KEY (APPLICATION_ID)
  REFERENCES APPM_APPLICATION (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX IF NOT EXISTS FK_APPLICATION_TAG_APPLICATION ON APPM_APPLICATION_TAG(APPLICATION_ID ASC);

DROP TABLE IF EXISTS APPM_APPLICATION_RELEASE;
DROP SEQUENCE IF EXISTS APPM_APPLICATION_RELEASE_PK_SEQ;
CREATE SEQUENCE APPM_APPLICATION_RELEASE_PK_SEQ;
-- -----------------------------------------------------
-- Table APPM_APPLICATION_RELEASE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS APPM_APPLICATION_RELEASE (
  ID INT DEFAULT NEXTVAL('APPM_APPLICATION_RELEASE_PK_SEQ') UNIQUE,
  VERSION_NAME VARCHAR(100) NOT NULL,
  RESOURCE TEXT NULL,
  RELEASE_CHANNEL VARCHAR(50) DEFAULT 'ALPHA',
  RELEASE_DETAILS TEXT NULL,
  CREATED_AT TIMESTAMP NOT NULL,
  APPM_APPLICATION_ID INT NOT NULL,
  IS_DEFAULT BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (APPM_APPLICATION_ID, VERSION_NAME),
  CONSTRAINT FK_APPLICATION_VERSION_APPLICATION
    FOREIGN KEY (APPM_APPLICATION_ID)
    REFERENCES APPM_APPLICATION (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX FK_APPLICATION_VERSION_APPLICATION ON APPM_APPLICATION_RELEASE(APPM_APPLICATION_ID ASC);

DROP TABLE IF EXISTS APPM_RELEASE_PROPERTY;
-- -----------------------------------------------------
-- Table APPM_RELEASE_PROPERTY
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS APPM_RELEASE_PROPERTY (
  PROP_KEY VARCHAR(255) NOT NULL,
  PROP_VALUE TEXT NULL,
  APPLICATION_RELEASE_ID INT NOT NULL,
  PRIMARY KEY (PROP_KEY, APPLICATION_RELEASE_ID),
  CONSTRAINT FK_RELEASE_PROPERTY_APPLICATION_RELEASE
    FOREIGN KEY (APPLICATION_RELEASE_ID)
    REFERENCES APPM_APPLICATION_RELEASE (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX FK_RELEASE_PROPERTY_APPLICATION_RELEASE ON APPM_RELEASE_PROPERTY(APPLICATION_RELEASE_ID ASC);