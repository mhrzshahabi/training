package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CommitteeDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.iservice.ICommitteeService;
import com.nicico.training.model.Committee;
import com.nicico.training.model.Personnel;
import com.nicico.training.repository.CommitteeDAO;
import com.nicico.training.repository.PersonnelDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class CommitteeService implements ICommitteeService {
    private final CommitteeDAO committeeDAO;
    private final PersonnelDAO personalInfoDAO;
    private final PersonnelDAO personnelDAO;
//       private final PersonnelService;
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
    public void delete(Long id) {
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
    public void addMembers(Long committeeId, Set<String> personInfoIds) {
        final Optional<Committee> optionalCommittee = committeeDAO.findById(committeeId);
        final Committee committee = optionalCommittee.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CommitteeNotFound));

//        Set<Personnel> personalSet = committee.getCommitteeMmembers();

        for (String personId : personInfoIds) {

            final Optional<Personnel> optionalPersonnel = personnelDAO.findOneByPersonnelNo(personId);
            final Personnel personnel = optionalPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PersonnelNotFound));
//            personalSet.add(personnel);
        }

//        committee.setCommitteeMmembers(personalSet);
    }

    @Transactional
    @Override
    public void removeMember(Long committeeId, String personInfiId) {

        final Optional<Committee> optionalCommittee = committeeDAO.findById(committeeId);
        final Committee committee = optionalCommittee.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CommitteeNotFound));

        final Optional<Personnel> optionalPersonnel = personnelDAO.findOneByPersonnelNo(personInfiId);
        final Personnel personalInfo = optionalPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PersonnelNotFound));

//        committee.getCommitteeMmembers().remove(personalInfo);


    }

    @Transactional
    @Override
    public void removeMembers(Long committeeId, Set<String> personIds) {
        for (String id : personIds) {
            removeMember(committeeId, id);
        }
    }

    @Transactional
    @Override
    public void addMember(Long committeeId, String personnelNo) {
        final Optional<Committee> optionalCommittee = committeeDAO.findById(committeeId);
        final Committee committee = optionalCommittee.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CommitteeNotFound));

        Optional<Personnel> byId = personnelDAO.findOneByPersonnelNo(personnelNo);
        final Personnel personnel = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PersonnelNotFound));
//        committee.getCommitteeMmembers().add(personnel);
    }

    @Transactional
    @Override
    public List<PersonnelDTO.Info> getMembers(Long committeeId) {
        final Optional<Committee> optionalCommittee = committeeDAO.findById(committeeId);
        final Committee committee = optionalCommittee.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CommitteeNotFound));

//        return mapper.map(committee.getCommitteeMmembers(), new TypeToken<List<PersonnelDTO.Info>>() {
//        }.getType());
        return null;
    }

//end add members functions

//    @Override
//    @Transactional
//    public Set<PersonnelDTO.Info> unAttachMember(Long committeeId) {
//        final Optional<Committee> optionalCommittee = committeeDAO.findById(committeeId);
//        final Committee committee = optionalCommittee.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CommitteeNotFound));
//        Set<Personnel> acctivePersonnelSet = committee.getCommitteeMmembers();
//        List<Personnel> personalInfoList = personalInfoDAO.findAll();
//        Set<Personnel> unAttach = new HashSet<>();
//        for (Personnel personalInfo : personalInfoList) {
//            if (!acctivePersonnelSet.contains(personalInfo))
//                unAttach.add(personalInfo);
//        }
//
//        Set<PersonnelDTO.Info> personInfoSet = new HashSet<>();
//        Optional.ofNullable(unAttach)
//                .ifPresent(person ->
//                        person.forEach(personal ->
//                                personInfoSet.add(mapper.map(personal, PersonnelDTO.Info.class))
//                        ));
//
//        return personInfoSet;
//        //  return mapper.map( unAttach, new TypeToken<List<PersonnelDTO.Info>>() {
//        //   }.getType());
//
//    }

    @Override
    @Transactional
    public boolean checkForDelete(Long CommitteeId) {
        Optional<Committee> committee = committeeDAO.findById(CommitteeId);
        final Committee committee1 = committee.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CommitteeNotFound));
//        Set<Personnel> personalInfoSet = committee1.getCommitteeMmembers();
//        return ((personalInfoSet != null && personalInfoSet.size() > 0 ? false : true));
        return false;
    }

    @Override
//    @Transactional
    public String findConflictCommittee(Long category, Long subcategory) {
        List<String> list = committeeDAO.findConflictCommittee(category, subcategory);
        if (list.size() > 0)
            return list.get(0);
        else
            return "";
    }

    @Override
    @Transactional
    public String findConflictWhenEdit(Long category, Long subcategory, Long id) {
        List<String> list = committeeDAO.findConflictWhenEdit(category, subcategory, id);
        if (list.size() > 0)
            return (list.get(0));
        else
            return null;
    }

}

