package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.ICompetenceRequestService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.IRequestItemService;
import com.nicico.training.model.CompetenceRequest;
import com.nicico.training.model.Personnel;
import com.nicico.training.model.RequestItem;
import com.nicico.training.repository.RequestItemDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.requestItem.RequestItemWithDiff;

import java.util.ArrayList;
import java.util.List;


@Service
@RequiredArgsConstructor
public class RequestItemService implements IRequestItemService {

    private final RequestItemDAO requestItemDAO;
    private final ICompetenceRequestService competenceRequestService;
    private final IPersonnelService personnelService;

    @Override
    @Transactional
    public RequestItem create(RequestItem requestItem) {
        CompetenceRequest competenceRequest= competenceRequestService.get(requestItem.getCompetenceReqId());
        requestItem.setCompetenceReq(competenceRequest);
        return requestItemDAO.save(requestItem);
    }

    @Override
    public RequestItem update(RequestItem newData, Long id) {
        RequestItem requestItem=get(id);
        requestItem.setAffairs(newData.getAffairs());
        requestItem.setCompetenceReq(newData.getCompetenceReq());
        requestItem.setCompetenceReqId(newData.getCompetenceReqId());
        requestItem.setLastName(newData.getLastName());
        requestItem.setName(newData.getName());
        requestItem.setWorkGroupCode(newData.getWorkGroupCode());
        requestItem.setPersonnelNumber(newData.getPersonnelNumber());
        requestItem.setPost(newData.getPost());
        requestItem.setState(newData.getState());
        return create(requestItem);
    }

    @Override
    public RequestItem get(Long id) {
        return requestItemDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Override
    public void delete(Long id) {
        requestItemDAO.deleteById(id);
    }

    @Override
    public List<RequestItem> getList() {
        return requestItemDAO.findAll();
    }

    @Override
    public Integer getTotalCount() {
        return Math.toIntExact(requestItemDAO.count());
    }

    @Override
    public List<RequestItem> search(SearchDTO.SearchRq request) {
        if (request.getStartIndex() != null) {
            Page<RequestItem> all = requestItemDAO.findAll(NICICOSpecification.of(request), NICICOPageable.of(request));
       return all.getContent();
        } else {
            return requestItemDAO.findAll(NICICOSpecification.of(request));
        }

    }

    @Override
    @Transactional
    public List<RequestItemWithDiff> createList(List<RequestItem> requestItems) {
        List<RequestItemWithDiff> requestItemWithDiffList=new ArrayList<>();
        for (RequestItem requestItem:requestItems){
            Personnel personnel= personnelService.getByPersonnelNumber(requestItem.getPersonnelNumber());

            RequestItemWithDiff requestItemWithDiff=new RequestItemWithDiff();
            requestItemWithDiff.setPersonnelNumber(requestItem.getPersonnelNumber());
            requestItemWithDiff.setName(requestItem.getName());
            requestItemWithDiff.setLastName(requestItem.getLastName());
            requestItemWithDiff.setPost(requestItem.getPost());
            requestItemWithDiff.setAffairs(requestItem.getAffairs());
             //todo after add workgroup
            requestItemWithDiff.setWorkGroupCode("");

            if (personnel!=null){
                requestItemWithDiff.setPersonnelNumberCorrect(true);
                if (personnel.getFirstName()!=null && personnel.getFirstName().trim().equals(requestItem.getName().trim())){
                    requestItemWithDiff.setNameCorrect(true);
                }else {
                    requestItemWithDiff.setCorrectName(personnel.getFirstName());
                    requestItemWithDiff.setNameCorrect(false);
                }
                if (personnel.getLastName()!=null && personnel.getLastName().trim().equals(requestItem.getLastName().trim())){
                    requestItemWithDiff.setLastNameCorrect(true);
                }else {
                    requestItemWithDiff.setCorrectLastName(personnel.getLastName());
                    requestItemWithDiff.setLastNameCorrect(false);
                }
                if (personnel.getCcpAffairs()!=null && personnel.getCcpAffairs().trim().equals(requestItem.getAffairs().trim())){
                    requestItemWithDiff.setAffairsCorrect(true);
                }else {
                    requestItemWithDiff.setCorrectAffairs(personnel.getCcpAffairs());
                    requestItemWithDiff.setAffairsCorrect(false);
                }
                create(requestItem);
            }else {
                requestItemWithDiff.setPersonnelNumberCorrect(false);
                requestItemWithDiff.setAffairsCorrect(false);
                requestItemWithDiff.setLastNameCorrect(false);
                requestItemWithDiff.setNameCorrect(false);
            }

            requestItemWithDiffList.add(requestItemWithDiff);

        }
        return requestItemWithDiffList;
    }


    @Override
    public List<RequestItem> getListWithCompetenceRequest(Long id) {
        return requestItemDAO.findAllByCompetenceReqId(id);
    }


}
