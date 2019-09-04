package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CommitteeDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.iservice.ICommitteeService;
import com.nicico.training.model.Committee;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.repository.CommitteeDAO;
import com.nicico.training.repository.PersonalInfoDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class CommitteeService implements ICommitteeService {
   private final CommitteeDAO committeeDAO;
   private final PersonalInfoDAO personalInfoDAO;
//   private final PersonalInfoService;
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




//    add members functions


    @Transactional
    @Override
    public void addMembers(Long committeeId, Set<Long> personInfoIds) {
          final Optional<Committee> optionalCommittee = committeeDAO.findById(committeeId);
        final Committee committee = optionalCommittee.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CommitteeNotFound));

        Set<PersonalInfo> personalInfoSet =committee.getCommitteeMmembers();

        for (Long personId : personInfoIds) {

            final Optional<PersonalInfo> optionalPersonalInfo = personalInfoDAO.findById(personId);
            final PersonalInfo personalInfo = optionalPersonalInfo.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PersonalInfoNotFound));
            personalInfoSet.add(personalInfo);
        }

        committee.setCommitteeMmembers(personalInfoSet);
    }

    @Transactional
    @Override
    public void removeMember(Long committeeId, Long personInfiId) {

          final Optional<Committee> optionalCommittee = committeeDAO.findById(committeeId);
        final Committee committee = optionalCommittee.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CommitteeNotFound));

       final Optional<PersonalInfo> optionalPersonalInfo = personalInfoDAO.findById(personInfiId);
        final PersonalInfo personalInfo = optionalPersonalInfo.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PersonalInfoNotFound));

        committee.getCommitteeMmembers().remove(personalInfo);



    }

    @Transactional
    @Override
    public void removeMembers(Long committeeId, Set<Long> personIds) {
         for (long id : personIds) {
            removeMember(committeeId,id);
        }
    }

    @Transactional
    @Override
    public void addMember(Long committeeId, Long personInfiId) {
        final Optional<Committee> optionalCommittee = committeeDAO.findById(committeeId);
        final Committee committee = optionalCommittee.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CommitteeNotFound));

        final Optional<PersonalInfo> optionalPersonalInfo = personalInfoDAO.findById(personInfiId);
        final PersonalInfo personalInfo = optionalPersonalInfo.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PersonalInfoNotFound));
        committee.getCommitteeMmembers().add(personalInfo);
    }

    @Transactional
    @Override
    public List<PersonalInfoDTO.Info> getMembers(Long committeeId) {
        final Optional<Committee> optionalCommittee = committeeDAO.findById(committeeId);
        final Committee committee = optionalCommittee.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CommitteeNotFound));

        return mapper.map( committee.getCommitteeMmembers(), new TypeToken<List<PersonalInfoDTO.Info>>() {
        }.getType());
    }

//end add members functions

    @Override
    @Transactional
    public Set<PersonalInfoDTO.Info> unAttachMember(Long committeeId)
 {
       final Optional<Committee> optionalCommittee = committeeDAO.findById(committeeId);
        final Committee committee = optionalCommittee.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CommitteeNotFound));
        Set<PersonalInfo> acctivePersonalInfoSet=committee.getCommitteeMmembers();
        List<PersonalInfo> personalInfoList=personalInfoDAO.findAll();
        Set<PersonalInfo> unAttach=new HashSet<>();
        for (PersonalInfo personalInfo : personalInfoList) {
         if(!acctivePersonalInfoSet.contains(personalInfo))
            unAttach.add(personalInfo);
     }

      Set<PersonalInfoDTO.Info> personInfoSet = new HashSet<>();
        Optional.ofNullable(unAttach)
                .ifPresent(person ->
                        person.forEach(personal ->
                                personInfoSet.add(mapper.map(personal,PersonalInfoDTO.Info.class))
                        ));

        return personInfoSet;
     //  return mapper.map( unAttach, new TypeToken<List<PersonalInfoDTO.Info>>() {
     //   }.getType());

 }

}
