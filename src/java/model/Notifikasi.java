package model;

import java.sql.ResultSet;
import java.time.LocalDateTime;

public class Notifikasi extends Model<Notifikasi> implements Updateable{

    private int idNotifikasi;
    private int idUser;
    private String judul;
    private String pesan;
    private LocalDateTime waktu;
    private String status; // read / unread
    
    // Convert ResultSet jadi object Notifikasi
    @Override
    Notifikasi toModel(ResultSet rs) {
        try {
            java.sql.Timestamp sqlTimestamp = rs.getTimestamp("waktu");
            LocalDateTime ldt = null;
            if (sqlTimestamp != null) {
                ldt = sqlTimestamp.toLocalDateTime();
            }
            return new Notifikasi(rs.getInt("idNotifikasi"), rs.getInt("idUser"), rs.getString("judul"), rs.getString("pesan"), ldt, rs.getString("status"));
        } catch (Exception e) {
            setMessage(e.getMessage());
        }
        return null;
    }

    // Constructor default, set nama tabel dan primary key
    public Notifikasi() {
        this.table = "notifikasi";
        this.primaryKey = "idNotifikasi";
    }
    
    // Constructor untuk insert baru (tanpa idNotifikasi)
    public Notifikasi(int idUser, String judul, String pesan, LocalDateTime waktu, String status) {
        this();
        this.idUser = idUser;
        this.judul = judul;
        this.pesan = pesan;
        this.waktu = waktu;
        this.status = status;
    }

    // Constructor lengkap dengan idNotifikasi (untuk read/update)
    public Notifikasi(int idNotifikasi, int idUser, String judul, String pesan, LocalDateTime waktu, String status) {
        this();
        this.idNotifikasi = idNotifikasi;
        this.idUser = idUser;
        this.judul = judul;
        this.pesan = pesan;
        this.waktu = waktu;
        this.status = status;
    }
    
    // SETTER DAN GETTER
    public int getId() {
        return idNotifikasi;
    }

    public void setId(int id) {
        this.idNotifikasi = id;
    }

    public int getIdUser() {
        return idUser;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

    public String getPesan() {
        return pesan;
    }

    public void setPesan(String pesan) {
        this.pesan = pesan;
    }

    public LocalDateTime getWaktu() {
        return waktu;
    }

    public void setWaktu(LocalDateTime waktu) {
        this.waktu = waktu;
    }

    public int getIdNotifikasi() {
        return idNotifikasi;
    }

    public void setIdNotifikasi(int idNotifikasi) {
        this.idNotifikasi = idNotifikasi;
    }

    public String getStatus() {
        return status;
    }
    
    @Override
    public void updateStatus(String status) {
        this.status = status;
    }

    public String getJudul() {
        return judul;
    }

    public void setJudul(String judul) {
        this.judul = judul;
    }
    
    // Mengembalikan banyaknya notifikasi yang belum dibaca
    public int getCountUnread(int idUser) {
        this.where("idUser = " + idUser + " AND status = 'unread'");
        return this.get().size();
    }
}
