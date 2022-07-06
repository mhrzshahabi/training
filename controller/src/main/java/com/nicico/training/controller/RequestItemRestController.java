package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.RequestItemCoursesDetailDTO;
import com.nicico.training.dto.RequestItemDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.mapper.requestItem.RequestItemBeanMapper;
import com.nicico.training.model.RequestItem;
import com.nicico.training.model.RequestItemProcessDetail;
import com.nicico.training.model.SynonymPersonnel;
import com.nicico.training.service.BaseService;
import dto.bpms.BPMSReqItemExpertsDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.requestItem.RequestItemDto;
import response.requestItem.RequestItemWithDiff;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/request-item")
public class RequestItemRestController {

    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;
    private final CriteriaUtil criteriaUtil;
    private final ICourseService courseService;
    private final IRequestItemService requestItemService;
    private final RequestItemBeanMapper requestItemBeanMapper;
    private final IParameterValueService parameterValueService;
    private final ISynonymPersonnelService synonymPersonnelService;
    private final IRequestItemProcessDetailService requestItemProcessDetailService;
    private final IRequestItemCoursesDetailService requestItemCoursesDetailService;


    @Loggable
    @PostMapping
    public ResponseEntity<RequestItemDTO.Info> create(@RequestBody RequestItemDTO.Create request) {
        RequestItem requestItem = requestItemBeanMapper.toRequestItem(request);
        RequestItem saved = requestItemService.create(requestItem,requestItem.getCompetenceReqId());
        RequestItemDTO.Info res = requestItemBeanMapper.toRequestItemDto(saved);
        return new ResponseEntity<>(res, HttpStatus.CREATED);
    }

    @Loggable
    @PostMapping(value = "/list")
    public ResponseEntity<RequestItemDto> createList(@RequestBody List<RequestItemDTO.Create> requests) {
        List<RequestItem> requestItem = requestItemBeanMapper.toRequestItemDtos(requests);
        RequestItemDto dto = requestItemService.createList(requestItem);
        return new ResponseEntity<>(dto, HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<RequestItemWithDiff> update(@PathVariable Long id, @RequestBody RequestItemDTO.Create request) {
        RequestItem competenceRequest = requestItemBeanMapper.toRequestItem(request);
        RequestItemWithDiff competenceRequestResponse = requestItemService.update(competenceRequest, id);
        return new ResponseEntity<>(competenceRequestResponse, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            requestItemService.delete(id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<RequestItemDTO.Info> get(@PathVariable Long id) {
        RequestItem competenceRequestResponse = requestItemService.get(id);
        RequestItemDTO.Info res = requestItemBeanMapper.toRequestItemDto(competenceRequestResponse);
        return new ResponseEntity<>(res, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<RequestItemDTO.Info>> list() {
        List<RequestItem> requestItems = requestItemService.getList();
        List<RequestItemDTO.Info> res = requestItemBeanMapper.toRequestItemDTODtos(requestItems);
        return new ResponseEntity<>(res, HttpStatus.OK);
    }

    @GetMapping(value = "/valid-data/{id}")
    public ResponseEntity<ISC<RequestItemWithDiff>> validData(HttpServletRequest iscRq, @PathVariable Long id) throws IOException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        List<RequestItemWithDiff> requestItemWithDiffList = new ArrayList<>();
        RequestItemWithDiff requestItemWithDiff = requestItemService.validData(id);
        requestItemWithDiffList.add(requestItemWithDiff);
        SearchDTO.SearchRs<RequestItemWithDiff> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setList(requestItemWithDiffList);
        searchRs.setTotalCount((long) requestItemWithDiffList.size());
        ISC<RequestItemWithDiff> infoISC = ISC.convertToIscRs(searchRs, searchRq.getStartIndex());

        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<RequestItemDTO.RequestItemSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                 @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                 @RequestParam(value = "_constructor", required = false) String constructor,
                                                                 @RequestParam(value = "operator", required = false) String operator,
                                                                 @RequestParam(value = "criteria", required = false) String criteria,
                                                                 @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        SearchDTO.CriteriaRq criteriaRq;

        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            request.setCriteria(criteriaRq);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }

        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        int id = 0;
        if (request.getCriteria() != null && request.getCriteria().getCriteria() != null) {
            for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
                if (criterion.getFieldName() != null) {
                    if (criterion.getFieldName().equals("competenceReqId")) {
                        id = (Integer) criterion.getValue().get(0);
                    }
                }
            }
        }

        List<RequestItem> totalResponse = requestItemService.search(request, (long) id);
        List<RequestItemDTO.Info> res = requestItemBeanMapper.toRequestItemDTODtos(totalResponse);

        final RequestItemDTO.SpecRs specResponse = new RequestItemDTO.SpecRs();
        final RequestItemDTO.RequestItemSpecRs specRs = new RequestItemDTO.RequestItemSpecRs();
        specResponse.setData(res)
                .setStartRow(startRow)
                .setEndRow(startRow + res.size())
                .setTotalRows(requestItemService.getTotalCount());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/operational-roles/{id}")
    public ResponseEntity updateOperationalRoles(@PathVariable Long id) {
        requestItemService.updateOperationalRoles(id);
        return new ResponseEntity<>(null, HttpStatus.OK);
    }

    @GetMapping(value = "/get-experts/{requestItemId}/{nationalCodes}")
    public ResponseEntity<ISC<BPMSReqItemExpertsDto>> getExperts(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                                 @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                                 @PathVariable Long requestItemId,
                                                                 @PathVariable List<String> nationalCodes) {

        List<BPMSReqItemExpertsDto> expertsDtoList = new ArrayList<>();
        for (String nationalCode : nationalCodes) {
            BPMSReqItemExpertsDto bpmsReqItemExpertsDto;
            SynonymPersonnel synonymPersonnel = synonymPersonnelService.getByNationalCode(nationalCode);
            if (synonymPersonnel == null) {
                SynonymPersonnel synonymPersonnelModel = new SynonymPersonnel();
                synonymPersonnelModel.setNationalCode(nationalCode);
                bpmsReqItemExpertsDto = modelMapper.map(synonymPersonnelModel, BPMSReqItemExpertsDto.class);
            } else {
                bpmsReqItemExpertsDto = modelMapper.map(synonymPersonnel, BPMSReqItemExpertsDto.class);
            }
            bpmsReqItemExpertsDto.setGeneralOpinion(parameterValueService.getInfo(requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(requestItemId, nationalCode).getExpertsOpinionId()).getTitle());
            expertsDtoList.add(bpmsReqItemExpertsDto);
        }

        ISC.Response<BPMSReqItemExpertsDto> response = new ISC.Response<>();
        response.setStartRow(startRow);
        response.setEndRow(startRow + expertsDtoList.size());
        response.setTotalRows(expertsDtoList.size());
        response.setData(expertsDtoList);
        ISC<BPMSReqItemExpertsDto> infoISC = new ISC<>(response);
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }

    @GetMapping(value = "/expert-opinion/{requestItemId}/{expertNationalCode}")
    public ResponseEntity<ISC<RequestItemCoursesDetailDTO.Info>> getExpertOpinion(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                                                  @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                                                  @PathVariable Long requestItemId,
                                                                                  @PathVariable String expertNationalCode) {

        RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(requestItemId, expertNationalCode);
        List<RequestItemCoursesDetailDTO.Info> requestItemCoursesDetails = requestItemCoursesDetailService.findAllByRequestItemProcessDetailId(requestItemProcessDetail.getId());

        ISC.Response<RequestItemCoursesDetailDTO.Info> response = new ISC.Response<>();
        response.setStartRow(startRow);
        response.setEndRow(startRow + requestItemCoursesDetails.size());
        response.setTotalRows(requestItemCoursesDetails.size());
        response.setData(requestItemCoursesDetails);
        ISC<RequestItemCoursesDetailDTO.Info> infoISC = new ISC<>(response);
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }

    @GetMapping(value = "/planning-chief-opinion/{requestItemId}")
    public ResponseEntity<RequestItemCoursesDetailDTO.OpinionInfo> getPlanningChiefOpinion(@PathVariable Long requestItemId) {

        String planningChiefNationalCode = requestItemService.getPlanningChiefNationalCode();
        RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(requestItemId, planningChiefNationalCode);
        RequestItemCoursesDetailDTO.OpinionInfo opinionInfo = requestItemCoursesDetailService.findAllOpinionByRequestItemProcessDetailId(requestItemProcessDetail.getId(),
                parameterValueService.getInfo(requestItemProcessDetail.getExpertsOpinionId()).getTitle());
        return new ResponseEntity<>(opinionInfo, HttpStatus.OK);
    }

    @GetMapping(value = "/courses-run-supervisor/{requestItemId}")
    public ResponseEntity<RequestItemCoursesDetailDTO.OpinionInfo> getCoursesRelatedToRunSupervisor(@PathVariable Long requestItemId) {

        List<RequestItemCoursesDetailDTO.Info> userCourses = new ArrayList<>();

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        SearchDTO.CriteriaRq categoryCriteriaRq = criteriaUtil.addPermissionToCriteria("Category", "categoryId");
        SearchDTO.CriteriaRq subCategoryCriteriaRq = criteriaUtil.addPermissionToCriteria("SubCategory", "subCategoryId");

        List<SearchDTO.CriteriaRq> catAndSubCatCriteriaList = new ArrayList<>();
        catAndSubCatCriteriaList.add(categoryCriteriaRq);
        catAndSubCatCriteriaList.add(subCategoryCriteriaRq);

        SearchDTO.CriteriaRq catAndSubCatCriteria = BaseService.makeNewCriteria(null, null, EOperator.or, catAndSubCatCriteriaList);
        BaseService.setCriteria(request, catAndSubCatCriteria);
        List<String> userAccessCourses = courseService.search(request).getList().stream().map(CourseDTO::getCode).collect(Collectors.toList());

        String planningChiefNationalCode = requestItemService.getPlanningChiefNationalCode();
        RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(requestItemId, planningChiefNationalCode);
        RequestItemCoursesDetailDTO.OpinionInfo opinionInfo = requestItemCoursesDetailService.findAllOpinionByRequestItemProcessDetailId(requestItemProcessDetail.getId(),
                parameterValueService.getInfo(requestItemProcessDetail.getExpertsOpinionId()).getTitle());
        List<RequestItemCoursesDetailDTO.Info> verifiedCoursesByPlanningChief = opinionInfo.getCourses();

        for (RequestItemCoursesDetailDTO.Info requestItemCoursesDetailDTO : verifiedCoursesByPlanningChief) {
            if (userAccessCourses.contains(requestItemCoursesDetailDTO.getCourseCode()))
                userCourses.add(requestItemCoursesDetailDTO);
        }
        opinionInfo.setCourses(userCourses);
        return new ResponseEntity<>(opinionInfo, HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/update-status/run-supervisor-to-experts")
    public ResponseEntity updateProcessStatusToRunExperts(@RequestParam Long requestItemId) {
        requestItemService.updateProcessStatus(requestItemId, "waitingReviewByRunExpertToHoldingCourses");
        return new ResponseEntity<>(null, HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/update-status/run-experts-to-supervisor-approval")
    public ResponseEntity updateProcessStatusToSupervisorApproval(@RequestParam Long requestItemId) {
        requestItemService.updateProcessStatus(requestItemId, "waitingFinalApprovalByRunSupervisor");
        return new ResponseEntity<>(null, HttpStatus.OK);
    }

}
