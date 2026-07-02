package com.ezc.aragenPR.webapp.dto.reservation;

import com.ezc.aragenPR.webapp.controller.pr.PRController;
import lombok.Data;

import java.time.LocalDate;
import java.util.List;
import com.ezc.aragenPR.webapp.dto.reservation.ReservationItemDTO;
@Data
public class ReservationDTO {

    private String reservationNo;
    private String movementType;

    private String wbs;
    private String wbsDesc;
    private String costCenter;
    private String goodsReceipt;
    private String internalOrder;
    private String network;
    private String activity;
    private String glAccount;

    private LocalDate reqDate;
    private String createdBy;
    private String status;

    private List<ReservationItemDTO> items;



}

