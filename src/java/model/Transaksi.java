package model;

import java.sql.ResultSet;
import java.time.LocalDateTime;

public class Transaksi extends Model<Transaksi> {

    private int idTransaksi;
    private int idPembeli;
    private LocalDateTime tanggalTransaksi;
    private double totalBayar;
    private String metodePembayaran;
    private String alamatPengiriman;

    // Constructor default, set nama tabel dan primary key
    public Transaksi() {
        this.table = "transaksi";
        this.primaryKey = "idTransaksi";
    }

    // Constructor untuk insert baru (tanpa idTransaksi)
    public Transaksi(int idPembeli, LocalDateTime tanggalTransaksi, double totalBayar, String metodePembayaran, String alamatPengiriman) {
        this();
        this.idPembeli = idPembeli;
        this.tanggalTransaksi = tanggalTransaksi;
        this.totalBayar = totalBayar;
        this.metodePembayaran = metodePembayaran;
        this.alamatPengiriman = alamatPengiriman;
    }

    // Constructor lengkap dengan idTransaksi (untuk read/update)
    public Transaksi(int idTransaksi, int idPembeli, LocalDateTime tanggalTransaksi, double totalBayar, String metodePembayaran, String alamatPengiriman) {
        this.idTransaksi = idTransaksi;
        this.idPembeli = idPembeli;
        this.tanggalTransaksi = tanggalTransaksi;
        this.totalBayar = totalBayar;
        this.metodePembayaran = metodePembayaran;
        this.alamatPengiriman = alamatPengiriman;
    }

    // Convert ResultSet jadi object Transaksi
    @Override
    public Transaksi toModel(ResultSet rs) {
        try {
            // Ambil timestamp dari kolom tanggalTransaksi
            java.sql.Timestamp sqlTimestamp = rs.getTimestamp("tanggalTransaksi");
            java.time.LocalDateTime ldt = null;
            if (sqlTimestamp != null) {
                ldt = sqlTimestamp.toLocalDateTime();
            }

            // Kembalikan objek Transaksi baru
            return new Transaksi(
                    rs.getInt("idTransaksi"),
                    rs.getInt("idPembeli"),
                    ldt,
                    rs.getDouble("totalBayar"),
                    rs.getString("metodePembayaran"),
                    rs.getString("alamatPengiriman")
            );
        } catch (Exception e) {
            setMessage(e.getMessage());
        }
        return null;
    }

    // SETTER DAN GETTER
    public int getIdTransaksi() {
        return idTransaksi;
    }

    public void setIdTransaksi(int idTransaksi) {
        this.idTransaksi = idTransaksi;
    }

    public int getIdPembeli() {
        return idPembeli;
    }

    public void setIdPembeli(int idPembeli) {
        this.idPembeli = idPembeli;
    }

    public LocalDateTime getTanggalTransaksi() {
        return tanggalTransaksi;
    }

    public void setTanggalTransaksi(LocalDateTime tanggalTransaksi) {
        this.tanggalTransaksi = tanggalTransaksi;
    }

    public double getTotalBayar() {
        return totalBayar;
    }

    public void setTotalBayar(double totalBayar) {
        this.totalBayar = totalBayar;
    }

    public String getMetodePembayaran() {
        return metodePembayaran;
    }

    public void setMetodePembayaran(String metodePembayaran) {
        this.metodePembayaran = metodePembayaran;
    }

    public String getAlamatPengiriman() {
        return alamatPengiriman;
    }

    public void setAlamatPengiriman(String alamatPengiriman) {
        this.alamatPengiriman = alamatPengiriman;
    }
}
