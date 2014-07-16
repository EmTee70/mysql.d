module mysql.mysql_result_test;

import std.stdio;
import dunit.toolkit;

import mysql.mysql;
import mysql.test_helper;
import mysql.test_config;

// MAKE AN SQL QUERY
unittest {
    auto mysql = testing_db_init();

    // create table
    mysql.query("CREATE TABLE mysql_d_table (
        id INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(100),
        date DATE,
        PRIMARY KEY (id)
    );");
    
    // list table
    auto q_res3 = mysql.query("show tables;");
    assertEqual(q_res3.length, 1);
    assertEqual(q_res3.front()["Tables_in_" ~ test_mysql_db], "mysql_d_table");

    // insert some
    mysql.query("INSERT INTO mysql_d_table (name, date) values (?, ?);", "Paul", "1989-05-06");
    assert(mysql.lastInsertId == 1);

    // select it
    auto res = mysql.query("select * from mysql_d_table;");
    assert(res.length == 1);
    assert(res.empty == false);

    assert(res.getFieldIndex("date") == 2);

    assert(res.fieldNames() == ["id", "name", "date"]);

    // this should raise an error
    res.getFieldIndex("column_which_not_exists").assertThrow!(Exception)("column_which_not_exists not in result");

    // TODO: fix mysql.close()
    // mysql.close();
}
