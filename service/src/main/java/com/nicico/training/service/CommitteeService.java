package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CommitteeDTO;
import com.nicico.training.iservice.ICommitteeService;
import com.nicico.training.model.Committee;
import com.nicico.training.repository.CommitteeDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CommitteeService implements ICommitteeService {
   private final CommitteeDAO committeeDAO;
   private final ModelMapper mapper;

 @Transactional(readOnly = true)
   @Override
    public CommitteeDTO.Info get(Long id) {
        final Optional<Committee> optionalCommittee = committeeDAO.findById(id);
        final Committee committee = optionalCommittee.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return mapper.map(committee, CommitteeDTO.Info.class);
    }

    @Transactional
    @Override
    public List<CommitteeDTO.Info> list() {
        List<Committee> committeeList = committeeDAO.findAll();
        return mapper.map(committeeList, new TypeToken<List<CommitteeDTO.Info>>() {
        }.getType());
    }

   @Transactional
    @Override
    public CommitteeDTO.Info create(CommitteeDTO.Create request) {
        Committee committee = mapper.map(request, Committee.class);
        return mapper.map(committeeDAO.saveAndFlush(committee), CommitteeDTO.Info.class);
    }

    @Transactional
    @Override
    public CommitteeDTO.Info update(Long id, CommitteeDTO.Update request) {
        Optional<Committee> optionalCommittee = committeeDAO.findById(id);
        Committee currentCommittee = optionalCommittee.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
         Committee committee = new Committee();
         mapper.map(currentCommittee, committee);
         mapper.map(request, committee);
        return mapper.map(committeeDAO.saveAndFlush(committee), CommitteeDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id)
 {
        committeeDAO.deleteById(id);
    }

    @Transactional
    @Override
        public void delete(CommitteeDTO.Delete request) {
         final List<Committee> jobList = committeeDAO.findAllById(request.getIds());
        committeeDAO.deleteAll(jobList);
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<CommitteeDTO.Info> search(SearchDTO.SearchRq request) {
       return SearchUtil.search(committeeDAO, request, committee -> mapper.map(committee, CommitteeDTO.Info.class));
    }

}
