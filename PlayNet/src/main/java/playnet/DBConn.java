package playnet;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConn {
	Connection conn = null;
	
	public Connection getConnection() {
		
		//String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
		//String dbID = "system";
		//String dbPass = "root";
		
		try {
			
			String jdbcUrl = "jdbc:mysql://localhost/mysql?serverTimezone=UTC&characterEncoding=UTF-8";
			String dbID = "root";
			String dbPass = "kgh256369!@";
			
			// 오라클 
			
			//Class.forName("oracle.jdbc.driver.OracleDriver");
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcUrl,dbID,dbPass);
			//System.out.println("성공");
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return conn;
	}
}
