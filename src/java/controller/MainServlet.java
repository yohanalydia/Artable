package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Produk;

@WebServlet(name = "MainServlet", urlPatterns = {"/Main", "/Home"})
public class MainServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String menu = request.getParameter("menu");

        try {
            // Default ke Home jika menu null atau kosong
            if (menu == null || "home".equals(menu)) {
                Produk p = new Produk();
                request.setAttribute("title", "New Products");

                // Ambil 5 produk terbaru
                p.addQuery("ORDER BY uploadTime DESC LIMIT 5");
                ArrayList<Produk> prods = p.get();

                request.setAttribute("list", prods);
                request.getRequestDispatcher("views/home.jsp").forward(request, response);

            } else if ("about".equals(menu)) {
                request.getRequestDispatcher("views/aboutUs.jsp").forward(request, response);

            } else if ("faq".equals(menu)) {
                // Redirect langsung ke Home dengan Anchor ID
                response.sendRedirect("Home#frequentlyAskedQuestions");
            }
        } catch (Exception e) {
            // Log error ke console NetBeans
            System.err.println("Error di MainServlet: " + e.getMessage());
            e.printStackTrace();

            // Kembali ke home dengan pesan error
            response.sendRedirect("Home?error=system_busy");
        }
    }
}
