package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.dto.TermDTO;
import com.nicico.training.iservice.ITermService;
import com.nicico.training.model.Job;
import com.nicico.training.model.Term;
import com.nicico.training.repository.JobDAO;
import com.nicico.training.repository.TermDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;
@Service
@RequiredArgsConstructor
public class TermService implements ITermService {
   private final TermDAO termDAO;
   private final ModelMapper mapper;

 @Transactional(readOnly = true)
   @Override
    public TermDTO.Info get(Long id) {
        final Optional<Term> optionalTerm = termDAO.findById(id);
        final Term term = optionalTerm.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
        return mapper.map(term, TermDTO.Info.class);
    }

    @Transactional
    @Override
    public List<TermDTO.Info> list() {
        List<Term> termList = termDAO.findAll();
        return mapper.map(termList, new TypeToken<List<TermDTO.Info>>() {
        }.getType());
    }

   @Transactional
    @Override
    public TermDTO.Info create(TermDTO.Create request) {
        Term term = mapper.map(request, Term.class);
        return mapper.map(termDAO.saveAndFlush(term), TermDTO.Info.class);
    }

    @Transactional
    @Override
    public TermDTO.Info update(Long id, TermDTO.Update request) {
        Optional<Term> optionalTerm = termDAO.findById(id);
        Term currentTerm = optionalTerm.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
         Term term = new Term();
         mapper.map(currentTerm, term);
         mapper.map(request, term);
        return mapper.map(termDAO.saveAndFlush(term), TermDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id)
 {
        termDAO.deleteById(id);
    }

    @Transactional
    @Override
        public void delete(TermDTO.Delete request) {
         final List<Term> jobList = termDAO.findAllById(request.getIds());
        termDAO.deleteAll(jobList);
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<TermDTO.Info> search(SearchDTO.SearchRq request) {
       return SearchUtil.search(termDAO, request, term -> mapper.map(term, TermDTO.Info.class));
    }

}
