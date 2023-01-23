package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.RequestItemCoursesDetailDTO;
import com.nicico.training.dto.RequestItemDTO;
import com.nicico.training.iservice.IRequestItemCoursesDetailService;
import com.nicico.training.iservice.IRequestItemProcessDetailService;
import com.nicico.training.iservice.IRequestItemService;
import com.nicico.training.model.RequestItemCoursesDetail;
import com.nicico.training.model.RequestItemProcessDetail;
import com.nicico.training.repository.RequestItemCoursesDetailDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
public class RequestItemCoursesDetailService implements IRequestItemCoursesDetailService {

    private final ModelMapper modelMapper;
    @Autowired
    @Lazy
    private IRequestItemService requestItemService;
    private final RequestItemCoursesDetailDAO requestItemCoursesDetailDAO;
    private final IRequestItemProcessDetailService requestItemProcessDetailService;

    @Override
    public RequestItemCoursesDetail create(RequestItemCoursesDetailDTO.Create create) {
        RequestItemCoursesDetail requestItemCoursesDetail = modelMapper.map(create, RequestItemCoursesDetail.class);
        return requestItemCoursesDetailDAO.saveAndFlush(requestItemCoursesDetail);
    }

    @Transactional(readOnly = true)
    @Override
    public RequestItemCoursesDetail findById(Long id) {
        Optional<RequestItemCoursesDetail> byId = requestItemCoursesDetailDAO.findById(id);
        return byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional
    @Override
    public void save(RequestItemCoursesDetail requestItemCoursesDetail) {
        requestItemCoursesDetailDAO.saveAndFlush(requestItemCoursesDetail);
    }

    @Override
    public List<RequestItemCoursesDetailDTO.Info> findAllByRequestItemProcessDetailId(Long requestItemProcessDetailId) {
        List<RequestItemCoursesDetail> requestItemCoursesDetails = requestItemCoursesDetailDAO.findAllByRequestItemProcessDetailId(requestItemProcessDetailId);
        return modelMapper.map(requestItemCoursesDetails, new TypeToken<List<RequestItemCoursesDetailDTO.Info>>() {
        }.getType());
    }

    @Override
    public RequestItemCoursesDetailDTO.OpinionInfo findAllOpinionByRequestItemProcessDetailId(Long requestItemProcessDetailId, String chiefOpinion, Long chiefOpinionId) {
        RequestItemCoursesDetailDTO.OpinionInfo opinionInfo = new RequestItemCoursesDetailDTO.OpinionInfo();
        List<RequestItemCoursesDetail> requestItemCoursesDetails = requestItemCoursesDetailDAO.findAllByRequestItemProcessDetailId(requestItemProcessDetailId);
        List<RequestItemCoursesDetailDTO.Info> infoList = modelMapper.map(requestItemCoursesDetails, new TypeToken<List<RequestItemCoursesDetailDTO.Info>>() {
        }.getType());
        opinionInfo.setCourses(infoList);
        opinionInfo.setFinalOpinion(chiefOpinion);
        opinionInfo.setFinalOpinionId(chiefOpinionId);

        return opinionInfo;
    }

    @Override
    public List<RequestItemCoursesDetailDTO.Info> findAllByRequestItem(Long requestItemId) {
        List<Long> requestItemProcessDetailIds = requestItemProcessDetailService.findAllByRequestItemId(requestItemId).stream().map(RequestItemProcessDetail::getId).collect(Collectors.toList());
        List<RequestItemCoursesDetail> requestItemCoursesDetails = requestItemCoursesDetailDAO.findAllByRequestItemProcessDetailIds(requestItemProcessDetailIds);
        Set<RequestItemCoursesDetail> requestItemCoursesDetailSet = new HashSet<>();
        for (RequestItemCoursesDetail requestItemCoursesDetail : requestItemCoursesDetails) {
            if (!requestItemCoursesDetailSet.stream().map(RequestItemCoursesDetail::getCourseCode).collect(Collectors.toList()).contains(requestItemCoursesDetail.getCourseCode()))
                requestItemCoursesDetailSet.add(requestItemCoursesDetail);
        }
        return modelMapper.map(requestItemCoursesDetailSet, new TypeToken<List<RequestItemCoursesDetailDTO.Info>>() {
        }.getType());
    }

    @Override
    public BaseResponse updateCoursesDetailAfterRunSupervisorReview(String processInstanceId, String taskId, String courseCode) {

        BaseResponse baseResponse = new BaseResponse();
        Long requestItemId = requestItemService.getIdByProcessInstanceId(processInstanceId);
        if (requestItemId != null) {
            Long requestItemProcessDetailId = requestItemProcessDetailService.findAllByRequestItemId(requestItemId).stream().filter(item -> item.getRoleName().equals("planningChief"))
                    .findFirst().map(RequestItemProcessDetail::getId).orElse(null);
            if (requestItemProcessDetailId != null) {
                List<RequestItemCoursesDetail> requestItemCoursesDetails = requestItemCoursesDetailDAO.findAllByRequestItemProcessDetailId(requestItemProcessDetailId);
                RequestItemCoursesDetail requestItemCoursesDetail = requestItemCoursesDetails.stream().filter(item -> item.getCourseCode().equals(courseCode)).findFirst().orElse(null);
                if (requestItemCoursesDetail != null) {
                    requestItemCoursesDetail.setTaskIdPerCourse(taskId);
                    requestItemCoursesDetail.setProcessState("بررسی کارشناس اجرا");
                    requestItemCoursesDetailDAO.saveAndFlush(requestItemCoursesDetail);
                    baseResponse.setStatus(HttpStatus.OK.value());
                } else
                    baseResponse.setStatus(HttpStatus.NOT_FOUND.value());
            } else
                baseResponse.setStatus(HttpStatus.NOT_FOUND.value());
        } else
            baseResponse.setStatus(HttpStatus.NOT_FOUND.value());
        return baseResponse;
    }

    @Override
    public BaseResponse updateCoursesDetailAfterRunExpertManualReview(String processInstanceId, String courseCode) {

        BaseResponse baseResponse = new BaseResponse();
        Long requestItemId = requestItemService.getIdByProcessInstanceId(processInstanceId);
        RequestItemDTO.Info info = requestItemService.getRequestItemProcessDetailByProcessInstanceId(processInstanceId);
        if (requestItemId != null) {
            Long requestItemProcessDetailId = requestItemProcessDetailService.findAllByRequestItemId(requestItemId).stream().filter(item -> item.getRoleName().equals("planningChief"))
                    .findFirst().map(RequestItemProcessDetail::getId).orElse(null);
            if (requestItemProcessDetailId != null) {
                List<RequestItemCoursesDetail> requestItemCoursesDetails = requestItemCoursesDetailDAO.findAllByRequestItemProcessDetailId(requestItemProcessDetailId);
                RequestItemCoursesDetail requestItemCoursesDetail = requestItemCoursesDetails.stream().filter(item -> item.getCourseCode().equals(courseCode)).findFirst().orElse(null);
                if (requestItemCoursesDetail != null) {
                    requestItemCoursesDetail.setProcessState("تایید دستی کارشناس اجرا");
                    Set<Long> classIds = requestItemCoursesDetailDAO.getClassIds(courseCode, info.getNationalCode());
                    requestItemCoursesDetail.setClassIds(classIds);

                    requestItemCoursesDetailDAO.saveAndFlush(requestItemCoursesDetail);
                    baseResponse.setStatus(HttpStatus.OK.value());
                } else
                    baseResponse.setStatus(HttpStatus.NOT_FOUND.value());
            } else
                baseResponse.setStatus(HttpStatus.NOT_FOUND.value());
        } else
            baseResponse.setStatus(HttpStatus.NOT_FOUND.value());
        return baseResponse;
    }

    @Override
    public void approveCompleteTasks() {
        try {
            List<RequestItemCoursesDetailDTO.CompleteTaskDto> list = new ArrayList<>();
            List<?> completeTasks = requestItemCoursesDetailDAO.getCompleteTasks();

            if (completeTasks != null) {
                for (Object completeTask : completeTasks) {
                    Object[] data = (Object[]) completeTask;
                    list.add(new RequestItemCoursesDetailDTO.CompleteTaskDto((data[0] != null ? Long.parseLong(data[0].toString()) : 0),
                            (data[1] != null ? (data[1].toString()) : ""),
                            (data[2] != null ? (data[2].toString()) : ""),
                            (data[3] != null ? (data[3].toString()) : ""),
                            (data[4] != null ? (data[4].toString()) : "")
                    ));
                }
            }
            list.forEach(completeTaskDto -> {
                Set<Long> classIds = requestItemCoursesDetailDAO.getClassIds(completeTaskDto.getCourseCode(), completeTaskDto.getUserNationalCode());
                completeTaskDto.setClassIds(classIds);
            });
            requestItemService.autoReviewRequestItemTaskByRunExperts(list);
        } catch (Exception e) {
            Logger.getLogger(RequestItemCoursesDetailService.class.getName()).log(Level.SEVERE, null, e);
        }
    }

    @Override
    public  boolean getByNationalCodeAndClassId(Long classId,String userNationalCode) {
        if (classId!=null && userNationalCode!=null){
            return !requestItemCoursesDetailDAO.getByNationalCodeAndClassId(classId, userNationalCode).isEmpty();
        }else {
            return false;
        }
    }

}
