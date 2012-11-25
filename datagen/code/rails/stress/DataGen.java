package code.rails.stress;


import java.sql.Connection;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DataGen {

    public static void main(String[] args) {

        Connection con = null;
        Statement st = null;
        ResultSet rs = null;

        String url = "jdbc:mysql://localhost:3306/nc_dev";
        String user = "root";
        String password = "root";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, password);
            st = con.createStatement();
            // create_10kStudents(st, "stu");
            // insert_random_questions(st);
            // create_test(st);
            // insert_student_tests(st);
            // insert_student
            insert_student_test_questions(st);
        } catch (Exception e) {
            e.printStackTrace(); 
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (st != null) {
                    st.close();
                }
                if (con != null) {
                    con.close();
                }

            } catch (Exception ex) {
            	ex.printStackTrace();
            }
        }
        
        System.out.println("done !!!! ");
    }
    
    private static void insert_student_test_questions(Statement st) {
		int start_id = 16;
		String command;
		Random rnd = new Random();
		try {
		for(int s = 20000; s <= 29999; s++) {
			for(int q = 20000; q <= 20004; q++) {
				command = "insert into student_test_questions values (" 
	    				+ start_id + ","
	    				+ s + "," // this is student id
	    				+ "10000" + "," // this is test id
	    				+ q + "," // question id
	    				+ (rnd.nextInt(3) + 1) + "," // choice
	    				+ (rnd.nextInt(2)) + "," // score
	    				+ "\"" + "2012-11-23 00:30:44" + "\"" + ","
	    				+ "\"" + "2012-11-29 10:30:44" + "\""  
	    				+ ")";
				start_id++;
	    		st.executeUpdate(command);
			}
		}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

	private static void insert_student_tests(Statement st) {
    	try {
    		String command;
    		Random rnd = new Random();
    		for(int test_taken_id = 20000; test_taken_id < 30000; test_taken_id++) {
    			command = "insert into student_tests values (" 
    				+ test_taken_id + ","
    				+ test_taken_id + "," // this is student id
    				+ "10000" + "," // this is test id
    				+ rnd.nextInt(6) + ","
    				+ "1" + ","
    				+ "\"" + "2012-11-23 00:30:44" + "\"" + ","
    				+ "\"" + "2012-11-29 10:30:44" + "\""  
    				+ ")";
    			st.executeUpdate(command);
    		}
    	}catch(Exception e) {
    		e.printStackTrace();
    	}
	}

	/*
     * mysql> desc tests;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| id         | int(11)      | NO   | PRI | NULL    | auto_increment |
| name       | varchar(255) | YES  |     | NULL    |                |
| start_date | datetime     | YES  |     | NULL    |                |
| end_date   | datetime     | YES  |     | NULL    |                |
| max_score  | int(11)      | YES  |     | NULL    |                |
| admin_id   | int(11)      | YES  |     | NULL    |                |
| level_id   | int(11)      | YES  |     | NULL    |                |
| created_at | datetime     | NO   |     | NULL    |                |
| updated_at | datetime     | NO   |     | NULL    |                |
+------------+--------------+------+-----+---------+----------------+
     */
    private static void create_test(Statement st) {
    	try {
    		String command;
    		command = "insert into tests values (" 
    				+ "10000" + ","
    				+ "\"" + "test_10000" + "\"" + ","
    				+ "\"" + "2012-11-23 00:30:44" + "\"" + ","
    				+ "\"" + "2012-11-29 10:30:44" + "\"" + ","
    				+  "15"  + ","
    				+  "1" + ","
    				+  "1" + ","
    				+ "\"" + "2012-11-23 00:30:44" + "\"" + ","
    				+ "\"" + "2012-11-23 00:30:44" + "\"" 
    				+ ")";
    		st.executeUpdate(command);
    	}catch(Exception e) {
    		e.printStackTrace();
    	}
    }

    /*
     * mysql> desc test_questions;
+----------------+--------------+------+-----+---------+----------------+
| Field          | Type         | Null | Key | Default | Extra          |
+----------------+--------------+------+-----+---------+----------------+
| id             | int(11)      | NO   | PRI | NULL    | auto_increment |
| test_id        | int(11)      | YES  |     | NULL    |                |
| content        | text         | YES  |     | NULL    |                |
| choice1        | varchar(255) | YES  |     | NULL    |                |
| choice2        | varchar(255) | YES  |     | NULL    |                |
| choice3        | varchar(255) | YES  |     | NULL    |                |
| choice4        | varchar(255) | YES  |     | NULL    |                |
| correct_choice | int(11)      | YES  |     | NULL    |                |
| score          | int(11)      | YES  |     | NULL    |                |
| created_at     | datetime     | NO   |     | NULL    |                |
| updated_at     | datetime     | NO   |     | NULL    |                |
+----------------+--------------+------+-----+---------+----------------+
11 rows in set (0.00 sec)

     */
    
    private static void insert_random_questions(Statement st) {
    	try {
    		Random rnd = new Random();
    		for(int qn = 0; qn < 5; qn++) {
    			int choice = rnd.nextInt(3) + 1;
    			String command = "" +
    					"insert into test_questions values " 
    					+ "("  
    					+ (20000 + qn) + ","
    					+ 10000 + ","
    									+ "\"" + "question content " + qn + "\"" + ","
    									+ "\"" + "choice 1" + "\"" + ","
    									+ "\"" + "choice 2" + "\"" + ","
    									+ "\"" + "choice 3" + "\"" + ","
    									+ "\"" + "choice 4" + "\"" + ","
    									+ choice + ","
    					+ "3" + ","
    					+ "\"" + "2012-11-23 00:30:44" + "\"" + ","
        				+ "\"" + "2012-11-23 00:30:44" + "\""
    					+ ")";
        		st.executeUpdate(command);

    		}
    	}catch(Exception e) {
    		e.printStackTrace();
    	}
    }
	private static void create_10kStudents(Statement st, String prefix) {
		try {
			for(int i = 0 ; i < 10000; i++) {
				String id = "" + (20000 + i);
				String fname = prefix + "_" + id;
				String lname = prefix + "_" + id;
				String perm_id = "" + id;
				String level = "1";
				String email = fname + "@cs290.com";
				String enc_pwd = "$2a$10$juCsIzg71guCCp9fRY2PP.iMQS.WzU12UDoBxbg0s1rAJnN5NWJaS";
				String created_at = "2012-11-23 00:30:44";
				String updated_at = "2012-11-23 00:30:44";
				String command = "insert into students (id, firstname,lastname, perm_id, level_id, mail_address, email, encrypted_password, created_at, updated_at) values " 
				+ "("
				+ id + ","
				+ "\"" + fname + "\"" + ","
				+ "\"" + lname + "\"" + ","
				+ "\"" + perm_id + "\"" + ","
				+ level + ","
				+ "\"" + "6510 El Colegio road, CA" + "\"" + ","
				+ "\"" + email + "\"" + ","
				+ "\"" + enc_pwd + "\"" + ","
				+ "\"" + created_at + "\"" + ","
				+ "\"" + updated_at + "\""
				+ ")";
				st.executeUpdate(command);
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
}
