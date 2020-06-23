/**
 * Author:    Mehran Golrokhi
 * Created:    1399.03.24
 * Description:    Use of WebService
 */


package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonObject;
import com.nicico.copper.common.dto.grid.GridResponse;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.ViewPostDTO;
import com.nicico.training.service.MasterDataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/masterData/")
public class MasterDataRestController {

    private final MasterDataService masterDataService;


    @GetMapping(value = "personnel/iscList")
    public ResponseEntity<TotalResponse<PersonnelDTO.Info>> getPersonnel(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        return new ResponseEntity<>(masterDataService.getPeople(iscRq,resp), HttpStatus.OK);
    }

    @GetMapping(value = "competence/iscList")
    public ResponseEntity<TotalResponse<CompetenceDTO.Info>> getCompetences(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        return new ResponseEntity<>(masterDataService.getCompetencies(iscRq,resp), HttpStatus.OK);
    }

    @GetMapping(value = "department/iscList")
    public ResponseEntity<TotalResponse<MasterDataService.CompetenceWebserviceDTO>> getDepartments(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        return new ResponseEntity<>(masterDataService.getDepartments(iscRq,resp), HttpStatus.OK);
    }

    @GetMapping(value = "post/iscList")
    public ResponseEntity<TotalResponse<ViewPostDTO.Info>> getposts(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        return new ResponseEntity<>(masterDataService.getPosts(iscRq,resp), HttpStatus.OK);
    }
}
