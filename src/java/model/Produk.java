package model;

import java.sql.ResultSet;
import java.time.LocalDateTime;

public class Produk extends Model<Produk> {
    private int idProduk;
    private String nama;
    private String kategori;
    private double harga;
    private String deskripsi;
    private int stok;
    private int idSeniman;
    private LocalDateTime uploadTime;
    private String imageUrl;
    private double berat;
    private String dimensi;
    private String material;
    
    
    @Override
    Produk toModel(ResultSet rs){
        try {
            java.sql.Timestamp sqlTimestamp = rs.getTimestamp("uploadTime");
            java.time.LocalDateTime ldt = null;
            if (sqlTimestamp != null) {
                ldt = sqlTimestamp.toLocalDateTime();
            }
            return new Produk(rs.getInt("idProduk"), rs.getString("nama"), rs.getString("kategori"), rs.getDouble("harga"), rs.getString("deskripsi"), rs.getInt("stok"), rs.getInt("idSeniman"), rs.getString("imageUrl"), ldt, rs.getDouble("berat"), rs.getString("dimensi"), rs.getString("material"));
        } catch (Exception e){
            setMessage(e.getMessage());
        }
        return null;
    }
    
    public Produk(){
        this.table = "produk";
        this.primaryKey = "idProduk";
    };
    
    public Produk(String nama, String kategori, double harga, String deskripsi, int stok, int idSeniman, String imageUrl, double berat, String dimensi, String material) {
        this.table = "produk";
        this.primaryKey = "idProduk";
        this.nama = nama;
        this.kategori = kategori;
        this.harga = harga;
        this.deskripsi = deskripsi;
        this.stok = stok;
        this.idSeniman = idSeniman;
        this.uploadTime = LocalDateTime.now();
        this.imageUrl = imageUrl;
        this.berat = berat;
        this.dimensi = dimensi;
        this.material = material;
    }
    
    public Produk(int id, String nama, String kategori, double harga, String deskripsi, int stok, int idSeniman, String imageUrl, LocalDateTime uploadTime, double berat, String dimensi, String material) {
        this.table = "produk";
        this.primaryKey = "idProduk";
        this.idProduk = id;
        this.nama = nama;
        this.kategori = kategori;
        this.harga = harga;
        this.deskripsi = deskripsi;
        this.stok = stok;
        this.idSeniman = idSeniman;
        this.uploadTime = uploadTime;
        this.imageUrl = imageUrl;
        this.berat = berat;
        this.dimensi = dimensi;
        this.material = material;
    }

    public int getIdProduk() {
        return idProduk;
    }

    public void setIdProduk(int idProduk) {
        this.idProduk = idProduk;
    }

    public String getNama() {
        return nama;
    }

    public void setNama(String nama) {
        this.nama = nama;
    }

    public String getKategori() {
        return kategori;
    }

    public void setKategori(String kategori) {
        this.kategori = kategori;
    }

    public double getHarga() {
        return harga;
    }

    public void setHarga(double harga) {
        this.harga = harga;
    }

    public String getDeskripsi() {
        return deskripsi;
    }

    public void setDeskripsi(String deskripsi) {
        this.deskripsi = deskripsi;
    }

    public int getStok() {
        return stok;
    }

    public void setStok(int stok) {
        this.stok = stok;
    }

    public int getIdSeniman() {
        return idSeniman;
    }

    public void setIdSeniman(int idSeniman) {
        this.idSeniman = idSeniman;
    }

    public LocalDateTime getUploadTime() {
        return uploadTime;
    }

    public void setUploadTime(LocalDateTime uploadTime) {
        this.uploadTime = uploadTime;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public double getBerat() {
        return berat;
    }

    public void setBerat(double berat) {
        this.berat = berat;
    }

    public String getDimensi() {
        return dimensi;
    }

    public void setDimensi(String dimensi) {
        this.dimensi = dimensi;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }
    
    
}

