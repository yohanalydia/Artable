package model;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

public abstract class Model<E> {

    private Connection con;
    private Statement stmt;
    private boolean isConnected;
    private String message;
    protected String table;
    protected String primaryKey;
    protected String select = "*";
    private String where = "";
    private String join = "";
    private String otherQuery = "";

    private void connect() {
        String db_name = "artable";
        String username = "root";
        String password = "";
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db_name, username, password);
            stmt = con.createStatement();
            isConnected = true;
            message = "Database Terkoneksi";
        } catch (Exception e) {
            isConnected = false;
            message = e.getMessage();
        }
    }

    private void disconnect() {
        try {
            stmt.close();
            con.close();
        } catch (Exception e) {
            message = e.getMessage();
        }
    }

    public void insert() {
        try {
            connect();
            String cols = "", values = "";

            // Ambil semua field dari class anak (User/Pembeli/Sekolah)
            for (Field field : this.getClass().getDeclaredFields()) {
                field.setAccessible(true);
                Object value = field.get(this);
                String fieldName = field.getName();

                // Tidak memasukkan field yang merupakan List/ArrayList/primaryKey
                if (value != null && !fieldName.equals(primaryKey)
                        && (value instanceof String || value instanceof Number || value instanceof Boolean || value instanceof java.util.Date || value instanceof java.time.LocalDateTime)) {

                    cols += fieldName + ", ";
                    values += value + "', '";
                }
            }

            // Jika tidak ada kolom yang ditemukan, jangan eksekusi
            if (cols.isEmpty()) {
                return;
            }

            // Membersihkan koma terakhir
            String query = "INSERT INTO " + table + " (" + cols.substring(0, cols.length() - 2) + ")"
                    + " VALUES ('" + values.substring(0, values.length() - 4) + "')";

            int result = stmt.executeUpdate(query);
            message = "info insert: " + result + " rows affected";

        } catch (Exception e) {
            System.err.println("SQL ERROR: " + e.getMessage()); // Cetak merah di console
            message = e.getMessage();
        } finally {
            disconnect();
        }
    }

    public void update() {
        try {
            connect();
            String values = "";
            Object pkValue = null;

            for (Field field : this.getClass().getDeclaredFields()) {
                field.setAccessible(true);
                Object value = field.get(this);
                String fieldName = field.getName();

                if (fieldName.equals(primaryKey)) {
                    pkValue = value;
                } else if (value != null && (value instanceof String || value instanceof Number || value instanceof Boolean)) {
                    values += fieldName + " = '" + value + "', ";
                }
            }

            if (values.isEmpty() || pkValue == null) {
                System.err.println("UPDATE ERROR: Values or PK is empty!");
                return;
            }

            String query = "UPDATE " + table + " SET " + values.substring(0, values.length() - 2)
                    + " WHERE " + primaryKey + " = '" + pkValue + "'";

            // DEBUG: Lihat query yang dihasilkan di Output NetBeans
//            System.out.println("DEBUG UPDATE QUERY: " + query);
            int result = stmt.executeUpdate(query);
            System.out.println("UPDATE INFO: " + result + " rows affected.");

            message = "info update: " + result + " rows affected";
        } catch (Exception e) {
            System.err.println("SQL UPDATE ERROR: " + e.getMessage());
            message = e.getMessage();
        } finally {
            disconnect();
        }
    }

    public void delete() {
        try {
            connect();
            Object pkValue = 0;
            for (Field field : this.getClass().getDeclaredFields()) {
                field.setAccessible(true);
                if (field.getName().equals(primaryKey)) {
                    pkValue = field.get(this);
                    break;
                }
            }
            int result = stmt.executeUpdate("DELETE FROM " + table + " WHERE " + primaryKey + " = '" + pkValue + "'");
            message = "info delete: " + result + " rows affected";
        } catch (Exception e) {
            message = e.getMessage();
        } finally {
            disconnect();
        }
    }

    ArrayList<Object> toRow(ResultSet rs) {
        ArrayList<Object> res = new ArrayList<>();
        int i = 1;
        try {
            while (true) {
                res.add(rs.getObject(i));
                i++;
            }
        } catch (Exception e) {

        }
        return res;
    }

    public ArrayList<ArrayList<Object>> query(String query) {
        ArrayList<ArrayList<Object>> res = new ArrayList<>();
        try {
            connect();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                res.add(toRow(rs));
            }
        } catch (Exception e) {
            message = e.getMessage();
        } finally {
            disconnect();
        }
        return res;
    }

    public ArrayList<E> get() {
        ArrayList<E> res = new ArrayList<>();
        try {
            connect();
            String query = "SELECT " + select + " FROM " + table;
            if (!join.equals("")) {
                query += join;
            }
            if (!where.equals("")) {
                query += " WHERE " + where;
            }
            if (!otherQuery.equals("")) {
                query += " " + otherQuery;
            }
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                res.add(toModel(rs));
            }
        } catch (Exception e) {
            message = e.getMessage();
        } finally {
            disconnect();
            select = "*";
            where = "";
            join = "";
            otherQuery = "";
        }
        return res;
    }

    public E find(String searchKey, String keyValue) {
        try {
            connect();
            String query = "SELECT " + select + " FROM " + table + " WHERE " + searchKey + " = '" + keyValue + "'";
            ResultSet rs = stmt.executeQuery(query);
            if (rs.next()) {
                return toModel(rs);
            }
        } catch (Exception e) {
            message = e.getMessage();
        } finally {
            disconnect();
            select = "*";
        }
        return null;
    }

    abstract E toModel(ResultSet rs);

    public void select(String cols) {
        select = cols;
    }

    public void join(String table, String on) {
        join += " JOIN " + table + " ON " + on;
    }

    public void where(String cond) {
        where = cond;
    }

    public void addQuery(String query) {
        otherQuery = query;
    }

    public boolean isConnected() {
        return isConnected;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
    
    // Agar bisa menjalankan query tanpa mengembalikan data
    public void executeCustom(String query) {
        try {
            connect();
            stmt.executeUpdate(query);
        } catch (Exception e) {
            System.err.println("SQL EXECUTE ERROR: " + e.getMessage());
            message = e.getMessage();
        } finally {
            disconnect();
        }
    }
}
