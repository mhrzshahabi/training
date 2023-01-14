package com.nicico.training.service;

import com.nicico.training.dto.RequestItemCoursesDetailDTO;
import com.nicico.training.iservice.IRequestItemCoursesDetailService;
import com.nicico.training.model.RequestItemCoursesDetail;
import com.nicico.training.model.RequestItemProcessDetail;
import com.nicico.training.repository.RequestItemCoursesDetailDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
public class RequestItemCoursesDetailService implements IRequestItemCoursesDetailService {

    private final ModelMapper modelMapper;
    private final RequestItemCoursesDetailDAO requestItemCoursesDetailDAO;
    private final RequestItemProcessDetailService requestItemProcessDetailService;

    @Override
    public RequestItemCoursesDetail create(RequestItemCoursesDetailDTO.Create create) {
        RequestItemCoursesDetail requestItemCoursesDetail = modelMapper.map(create, RequestItemCoursesDetail.class);
        return requestItemCoursesDetailDAO.saveAndFlush(requestItemCoursesDetail);
    }

    @Override
    public List<RequestItemCoursesDetailDTO.Info> findAllByRequestItemProcessDetailId(Long requestItemProcessDetailId) {
        List<RequestItemCoursesDetail> requestItemCoursesDetails = requestItemCoursesDetailDAO.findAllByRequestItemProcessDetailId(requestItemProcessDetailId);
        return modelMapper.map(requestItemCoursesDetails, new TypeToken<List<RequestItemCoursesDetailDTO.Info>>(){}.getType());
    }

    @Override
    public RequestItemCoursesDetailDTO.OpinionInfo findAllOpinionByRequestItemProcessDetailId(Long requestItemProcessDetailId, String chiefOpinion, Long chiefOpinionId) {
        RequestItemCoursesDetailDTO.OpinionInfo opinionInfo = new RequestItemCoursesDetailDTO.OpinionInfo();
        List<RequestItemCoursesDetail> requestItemCoursesDetails = requestItemCoursesDetailDAO.findAllByRequestItemProcessDetailId(requestItemProcessDetailId);
        List<RequestItemCoursesDetailDTO.Info> infoList = modelMapper.map(requestItemCoursesDetails, new TypeToken<List<RequestItemCoursesDetailDTO.Info>>(){}.getType());
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
        return modelMapper.map(requestItemCoursesDetailSet, new TypeToken<List<RequestItemCoursesDetailDTO.Info>>(){}.getType());
    }

    @Scheduled(cron = "0 30 17 1/1 * ?")
//    @Scheduled(cron = "*/1 * * * * ?") //every minute
    @Transactional
    public void approveCompleteTasks() {
        try {
            List<RequestItemCoursesDetailDTO.CompleteTaskDto> list = new ArrayList<>();

            List<?> completeTasks = requestItemCoursesDetailDAO.getCompleteTasks();

            if (completeTasks != null) {
                for (Object completeTask : completeTasks) {
                    Object[] data = (Object[]) completeTask;
                    list.add(new RequestItemCoursesDetailDTO.CompleteTaskDto((data[0] != null ? Long.parseLong(data[0].toString()) : 0),
                            (data[1] != null ? (data[1].toString()) : ""),
                            (data[2] != null ? (data[2].toString()) : "")
                    ));
                }
            }
            //todo shahabi approve Complete Tasks

            }catch(Exception e){
            Logger.getLogger(RequestItemCoursesDetailService.class.getName()).log(Level.SEVERE, null, e);
            }



    }

}
