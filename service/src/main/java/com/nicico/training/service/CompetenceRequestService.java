package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.ICompetenceRequestService;
import com.nicico.training.model.CompetenceRequest;
import com.nicico.training.repository.CompetenceRequestDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
@RequiredArgsConstructor
public class CompetenceRequestService implements ICompetenceRequestService {

    private final CompetenceRequestDAO competenceRequestDAO;

    @Override
    public CompetenceRequest create(CompetenceRequest competenceRequest) {
        return competenceRequestDAO.save(competenceRequest);
    }

    @Override
    public CompetenceRequest update(CompetenceRequest newCompetenceReq, Long id) {
        CompetenceRequest competenceRequest=get(id);
        competenceRequest.setApplicant(newCompetenceReq.getApplicant());
        competenceRequest.setLetterNumber(newCompetenceReq.getLetterNumber());
        competenceRequest.setRequestDate(newCompetenceReq.getRequestDate());
        competenceRequest.setRequestType(newCompetenceReq.getRequestType());
        return create(competenceRequest);
    }

    @Override
    public CompetenceRequest get(Long id) {
        return competenceRequestDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Override
    public void delete(Long id) {
        competenceRequestDAO.deleteById(id);
    }

    @Override
    public List<CompetenceRequest> getList() {
        return competenceRequestDAO.findAll();
    }

    @Override
    public Integer getTotalCount() {
        return Math.toIntExact(competenceRequestDAO.count());
    }

    @Override
    public List<CompetenceRequest> search(SearchDTO.SearchRq request) {
        if (request.getStartIndex() != null) {
            Page<CompetenceRequest> all = competenceRequestDAO.findAll(NICICOSpecification.of(request), NICICOPageable.of(request));
       return all.getContent();
        } else {
            return competenceRequestDAO.findAll(NICICOSpecification.of(request));
        }

    }

}
