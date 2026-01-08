package model;

import java.sql.ResultSet;

public class User extends Model<User> {

    private int idUser;
    protected String nama;
    protected String username;
    protected String email;
    protected String password;
    protected String alamat;
    protected String nomorTelepon;
    protected String role;
    protected String imageUrl;
    protected String tipeRekening;
    protected String nomorRekening;

    public User() {
        this.table = "user";
        this.primaryKey = "idUser";
    };
    
    // Constructor untuk input user baru (id belum terbentuk)// Constructor untuk input user baru (id belum terbentuk)
    public User(String nama, String username, String email, String password, String alamat, String nomorTelepon, String role, String imageUrl, String tipeRekening, String nomorRekening) {
        this();
        this.nama = nama;
        this.username = username;
        this.email = email;
        this.password = password;
        this.alamat = alamat;
        this.nomorTelepon = nomorTelepon;
        this.role = role;
        this.tipeRekening = tipeRekening;
        this.nomorRekening = nomorRekening;
        this.imageUrl = imageUrl;
    }

    // Constructor untuk data dari database (id telah terbentuk)
    public User(int idUser, String nama, String username, String email, String password, String alamat, String nomorTelepon, String role, String imageUrl, String tipeRekening, String nomorRekening) {
        this();
        this.idUser = idUser;
        this.nama = nama;
        this.username = username;
        this.email = email;
        this.password = password;
        this.alamat = alamat;
        this.nomorTelepon = nomorTelepon;
        this.role = role;
        this.tipeRekening = tipeRekening;
        this.nomorRekening = nomorRekening;
        this.imageUrl = imageUrl;
    }
    
    public void setNama(String nama) {
        this.nama = nama;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setAlamat(String alamat) {
        this.alamat = alamat;
    }

    public void setNomorTelepon(String nomorTelepon) {
        this.nomorTelepon = nomorTelepon;
    }

    public int getIdUser() {
        return idUser;
    }

    public String getNama() {
        return nama;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getAlamat() {
        return alamat;
    }

    public String getNomorTelepon() {
        return nomorTelepon;
    }

    public String getRole() {
        return role;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getTipeRekening() {
        return tipeRekening;
    }

    public void setTipeRekening(String tipeRekening) {
        this.tipeRekening = tipeRekening;
    }

    public String getNomorRekening() {
        return nomorRekening;
    }

    public void setNomorRekening(String nomorRekening) {
        this.nomorRekening = nomorRekening;
    }
    

    @Override
    public User toModel(ResultSet rs) {
        try {
            User u = new User(
                    rs.getInt("idUser"),
                    rs.getString("nama"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("alamat"),
                    rs.getString("nomorTelepon"),
                    rs.getString("role"),
                    rs.getString("imageUrl"),
                    rs.getString("tipeRekening"), 
                    rs.getString("nomorRekening")
            );
            
            return u;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
