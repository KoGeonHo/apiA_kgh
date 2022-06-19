package playnet.common;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConn {
	Connection conn = null;
	
	public Connection getConnection() {
		
		//String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
		//String dbID = "system";
		//String dbPass = "root";
		
		try {
			
			String jdbcUrl = "jdbc:mysql://kgh5247.cafe24.com/kgh5247?serverTimezone=UTC&characterEncoding=UTF-8";
			String dbID = "kgh5247";
			String dbPass = "playnetstudy!@";
			
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
