package controller;

import dal.VoucherDAO;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Voucher;

@WebServlet(name = "AdminVoucherController", urlPatterns = {"/admin/vouchers"})
public class AdminVoucherController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        VoucherDAO vDao = new VoucherDAO();

        if ("toggle".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    vDao.toggleStatus(id);
                    request.getSession().setAttribute("message", "Đã thay đổi trạng thái voucher thành công!");
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/vouchers");
            return;

        } else if ("add".equalsIgnoreCase(action)) {
            request.setAttribute("formAction", "add");
            request.getRequestDispatcher("/admin/voucher-form.jsp").forward(request, response);
            return;

        } else if ("edit".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    Voucher v = vDao.getById(id);
                    if (v != null) {
                        request.setAttribute("voucher", v);
                        request.setAttribute("formAction", "edit");
                        request.getRequestDispatcher("/admin/voucher-form.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/vouchers");
            return;
        }

        // List action (default)
        List<Voucher> list = vDao.getAll();
        request.setAttribute("vouchers", list);
        request.getRequestDispatcher("/admin/vouchers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String formAction = request.getParameter("formAction");
        String idStr = request.getParameter("id");
        String code = request.getParameter("code");
        String discountType = request.getParameter("discountType");
        String discountValueStr = request.getParameter("discountValue");
        String minOrderValueStr = request.getParameter("minOrderValue");
        String maxDiscountAmountStr = request.getParameter("maxDiscountAmount");
        String qtyStr = request.getParameter("quantity");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String statusStr = request.getParameter("status"); // checkbox: "on" or null

        // Validation
        if (code == null || code.trim().isEmpty() ||
            discountType == null || discountType.isEmpty() ||
            discountValueStr == null || discountValueStr.isEmpty() ||
            qtyStr == null || qtyStr.isEmpty() ||
            startDateStr == null || startDateStr.isEmpty() ||
            endDateStr == null || endDateStr.isEmpty()) {

            request.setAttribute("error", "Vui lòng nhập đầy đủ các trường bắt buộc!");
            repopulateForm(request, response);
            return;
        }

        double discountValue = 0;
        double minOrderValue = 0;
        double maxDiscountAmount = 0;
        int qty = 0;
        Timestamp startDate = null;
        Timestamp endDate = null;

        try {
            discountValue = Double.parseDouble(discountValueStr);
            qty = Integer.parseInt(qtyStr);
            if (minOrderValueStr != null && !minOrderValueStr.isEmpty()) {
                minOrderValue = Double.parseDouble(minOrderValueStr);
            }
            if (maxDiscountAmountStr != null && !maxDiscountAmountStr.isEmpty()) {
                maxDiscountAmount = Double.parseDouble(maxDiscountAmountStr);
            }

            if (discountValue <= 0 || qty < 0 || minOrderValue < 0 || maxDiscountAmount < 0) {
                request.setAttribute("error", "Các giá trị số lượng/tiền không được âm và giá trị giảm phải lớn hơn 0!");
                repopulateForm(request, response);
                return;
            }

            if ("Percentage".equalsIgnoreCase(discountType) && discountValue > 100) {
                request.setAttribute("error", "Loại giảm giá phần trăm không được lớn hơn 100%!");
                repopulateForm(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Giá trị nhập vào không đúng định dạng số!");
            repopulateForm(request, response);
            return;
        }

        try {
            startDate = Timestamp.valueOf(LocalDateTime.parse(startDateStr));
            endDate = Timestamp.valueOf(LocalDateTime.parse(endDateStr));

            if (endDate.before(startDate)) {
                request.setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu!");
                repopulateForm(request, response);
                return;
            }
        } catch (DateTimeParseException e) {
            request.setAttribute("error", "Định dạng ngày giờ không hợp lệ!");
            repopulateForm(request, response);
            return;
        }

        VoucherDAO vDao = new VoucherDAO();
        boolean status = "on".equals(statusStr) || "true".equals(statusStr);
        code = code.trim().toUpperCase();

        if ("add".equalsIgnoreCase(formAction)) {
            // Check unique code
            if (vDao.getByCode(code) != null) {
                request.setAttribute("error", "Mã voucher '" + code + "' đã tồn tại trên hệ thống!");
                repopulateForm(request, response);
                return;
            }

            Voucher v = new Voucher(0, code, discountType, discountValue, minOrderValue, maxDiscountAmount, qty, startDate, endDate, status);
            try {
                boolean success = vDao.insert(v);
                if (success) {
                    request.getSession().setAttribute("message", "Thêm mã giảm giá thành công!");
                    response.sendRedirect(request.getContextPath() + "/admin/vouchers");
                } else {
                    request.setAttribute("error", "Thêm thất bại do lỗi hệ thống!");
                    repopulateForm(request, response);
                }
            } catch (java.sql.SQLException ex) {
                request.setAttribute("error", "Thêm thất bại do lỗi cơ sở dữ liệu: " + ex.getMessage());
                repopulateForm(request, response);
            }
        } else if ("edit".equalsIgnoreCase(formAction)) {
            try {
                int id = Integer.parseInt(idStr);
                Voucher existing = vDao.getById(id);
                if (existing == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/vouchers");
                    return;
                }

                // Check unique code if code was changed
                if (!existing.getCode().equalsIgnoreCase(code)) {
                    if (vDao.getByCode(code) != null) {
                        request.setAttribute("error", "Mã voucher '" + code + "' đã tồn tại trên hệ thống!");
                        repopulateForm(request, response);
                        return;
                    }
                }

                Voucher v = new Voucher(id, code, discountType, discountValue, minOrderValue, maxDiscountAmount, qty, startDate, endDate, status);
                try {
                    boolean success = vDao.update(v);
                    if (success) {
                        request.getSession().setAttribute("message", "Cập nhật mã giảm giá thành công!");
                        response.sendRedirect(request.getContextPath() + "/admin/vouchers");
                    } else {
                        request.setAttribute("error", "Cập nhật thất bại do lỗi hệ thống!");
                        repopulateForm(request, response);
                    }
                } catch (java.sql.SQLException ex) {
                    request.setAttribute("error", "Cập nhật thất bại do lỗi cơ sở dữ liệu: " + ex.getMessage());
                    repopulateForm(request, response);
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/vouchers");
            }
        }
    }

    private void repopulateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Voucher v = new Voucher();
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                v.setId(Integer.parseInt(idStr));
            } catch (NumberFormatException e) {}
        }
        v.setCode(request.getParameter("code"));
        v.setDiscountType(request.getParameter("discountType"));
        try {
            v.setDiscountValue(Double.parseDouble(request.getParameter("discountValue")));
        } catch (Exception e) {}
        try {
            v.setMinOrderValue(Double.parseDouble(request.getParameter("minOrderValue")));
        } catch (Exception e) {}
        try {
            v.setMaxDiscountAmount(Double.parseDouble(request.getParameter("maxDiscountAmount")));
        } catch (Exception e) {}
        try {
            v.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        } catch (Exception e) {}
        
        // Handle dates repopulation
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        try {
            if (startDateStr != null && !startDateStr.isEmpty()) {
                v.setStartDate(Timestamp.valueOf(LocalDateTime.parse(startDateStr)));
            }
        } catch (Exception e) {}
        try {
            if (endDateStr != null && !endDateStr.isEmpty()) {
                v.setEndDate(Timestamp.valueOf(LocalDateTime.parse(endDateStr)));
            }
        } catch (Exception e) {}

        v.setStatus("on".equals(request.getParameter("status")));

        request.setAttribute("voucher", v);
        request.setAttribute("formAction", request.getParameter("formAction"));
        request.getRequestDispatcher("/admin/voucher-form.jsp").forward(request, response);
    }
}
