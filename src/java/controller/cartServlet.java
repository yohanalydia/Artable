package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Pembeli;
import model.Cart;
import model.CartItem;
import model.Produk;

@WebServlet(name = "CartServlet", urlPatterns = {"/CartServlet"})
public class cartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pembeli user = (Pembeli) session.getAttribute("user");

        // Proteksi: Harus login sebagai Pembeli
        if (user == null) {
            response.sendRedirect("Auth");
            return;
        }

        String action = request.getParameter("action");
        Cart myCart = new Cart().find("idUser", String.valueOf(user.getIdUser()));

        try {
            if (action == null || "view".equals(action)) {
                CartItem itemModel = new CartItem();
                itemModel.where("idCart = '" + myCart.getIdCart() + "'");
                itemModel.addQuery("ORDER BY updateTime DESC");

                ArrayList<CartItem> sortedItems = itemModel.get();

                request.setAttribute("cart", sortedItems);
                
                double total = 0;
                for (CartItem items: sortedItems){
                    Produk p = new Produk().find("idProduk", String.valueOf(items.getIdProduk()));
                    total += items.getQuantity() * p.getHarga();
                }
                request.setAttribute("subtotal", total);
                request.getRequestDispatcher("views/cart.jsp").forward(request, response);
            } else {
                // Jika ada aksi lain lewat GET yang seharusnya lewat POST, lempar ke view
                response.sendRedirect("CartServlet?action=view");
            }
        } catch (Exception e) {
            System.err.println("Error di CartServlet (doGet): " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("Home?error=cart_load_failed");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pembeli user = (Pembeli) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("Auth");
            return;
        }

        String action = request.getParameter("action");
        Cart myCart = new Cart().find("idUser", String.valueOf(user.getIdUser()));

        try {
            if ("add".equals(action)) {
                String idProduk = request.getParameter("id");
                String qtyInput = request.getParameter("qty");
                int qty = (qtyInput != null) ? Integer.parseInt(qtyInput) : 1;

                Produk p = new Produk().find("idProduk", idProduk);
                if (p == null) {
                    response.sendRedirect("Produk?menu=shop&error=ProductNotFound");
                    return;
                }

                CartItem itemModel = new CartItem();
                itemModel.where("idCart = '" + myCart.getIdCart() + "' AND idProduk = '" + idProduk + "'");
                ArrayList<CartItem> existingItems = itemModel.get();

                if (!existingItems.isEmpty()) {
                    CartItem item = existingItems.get(0);
                    int totalQty = item.getQuantity() + qty;
                    if (totalQty <= p.getStok()) {
                        item.setQuantity(totalQty);
                        item.update();
                    } else {
                        session.setAttribute("cartError", "Maaf, stok '" + p.getNama() + "' hanya tersisa " + p.getStok() + " unit.");
                    }
                } else {
                    if (p.getStok() > 0) {
                        CartItem newItem = new CartItem();
                        newItem.setIdCart(myCart.getIdCart());
                        newItem.setIdProduk(Integer.parseInt(idProduk));
                        if (qty > p.getStok()) {
                            qty = p.getStok();
                        }
                        newItem.setQuantity(qty);
                        newItem.insert();
                        newItem.update();
                    } else {
                        session.setAttribute("cartError", "Maaf, stok '" + p.getNama() + "' habis.");
                    }
                }

            } else if ("remove".equals(action)) {
                String idItem = request.getParameter("idItem");
                System.out.println("masuk remove");
                if (idItem != null) {
                    CartItem itemToDelete = new CartItem();
                    // Set nilai ID ke properti yang merupakan Primary Key
                    itemToDelete.setIdCartItem(Integer.parseInt(idItem));

                    // DEBUG: Cek di console apakah ID-nya benar masuk
                    System.out.println("Menghapus item ID: " + idItem);

                    itemToDelete.delete();
                }
            } else if ("update".equals(action)) {
                String idItem = request.getParameter("idItem");
                String op = request.getParameter("op");

                CartItem itemModel = new CartItem().find("idCartItem", idItem);
                if (itemModel != null) {
                    Produk p = new Produk().find("idProduk", String.valueOf(itemModel.getIdProduk()));
                    int currentQty = itemModel.getQuantity();

                    if ("add".equals(op)) {
                        if (currentQty < p.getStok()) {
                            itemModel.addQuantity();
                            itemModel.update();
                        } else {
                            session.setAttribute("cartError", "Maaf, stok '" + p.getNama() + "' hanya tersisa " + p.getStok() + " unit.");
                        }
                    } else if ("min".equals(op) && currentQty > 1) {
                        itemModel.setQuantity(currentQty - 1);
                        itemModel.update();
                        session.removeAttribute("cartError");
                    }
                }
            }

            // Apapun aksi POST-nya, setelah selesai arahkan ke tampilan Cart
            response.sendRedirect("CartServlet?action=view");

        } catch (Exception e) {
            System.err.println("Error di CartServlet (doPost): " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("CartServlet?action=view&error=action_failed");
        }
    }
}
