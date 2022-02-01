package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.ViewActivePersonnelDTO;
import com.nicico.training.iservice.ISynonymPersonnelService;
import com.nicico.training.model.SynonymPersonnel;
import com.nicico.training.repository.SynonymPersonnelDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SynonymPersonnelService implements ISynonymPersonnelService {
    private final SynonymPersonnelDAO dao;
    private final ModelMapper modelMapper;
    @Autowired
    EntityManager entityManager;


    @Transactional(readOnly = true)
    public TotalResponse<PersonnelDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(dao, request, SynonymPersonnel -> modelMapper.map(SynonymPersonnel, PersonnelDTO.Info.class));
    }

    public SynonymPersonnel getByNationalCode(String nationalCode) {
        return dao.findSynonymPersonnelDataByNationalCode(nationalCode);
    }

    @Transactional
    public ViewActivePersonnelDTO.PersonalityInfo getByPersonnelCode(String personnelCode) {
        Optional<SynonymPersonnel> optPersonnel = dao.findByPersonnelNoAndDeleted(personnelCode,0);
        final SynonymPersonnel personnel = optPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(personnel, ViewActivePersonnelDTO.PersonalityInfo.class);
    }

//    @Transactional
//    public List<PersonnelDTO.InfoForStudent> checkSynonymPersonnelNos(List<String> personnelNos, Long courseId) {
//        List<PersonnelDTO.InfoForStudent> result = new ArrayList<>();
//        String query = "SELECT PERSONNEL_NO,IS_IN_NA,CLASS_STUDENT_SCORES_STATE_ID FROM view_active_personnel_for_register_in_class WHERE ";
//        String query1 = "";
//        List<SynonymPersonnel> list = dao.findByPersonnelNoInOrPersonnelNo2In(personnelNos, personnelNos);
//        SynonymPersonnel prs = null;
//        for (String personnelNo : personnelNos) {
//            List<SynonymPersonnel> list2 = list.stream().filter(p -> (p.getDeleted() == null || p.getDeleted().equals(0)) && (p.getPersonnelNo() != null && p.getPersonnelNo().equals(personnelNo)) || (p.getPersonnelNo2() != null && p.getPersonnelNo2().equals(personnelNo))).collect(Collectors.toList());
//            if (list2 == null || list2.size() == 0) {
//                result.add(new PersonnelDTO.InfoForStudent());
//
//            } else {
//                prs = list2.get(0);
//                result.add(modelMapper.map(prs, PersonnelDTO.InfoForStudent.class));
//                query1 += "(PERSONNEL_NO='" + prs.getPersonnelNo() + "' and COURSE_ID=" + courseId + " ) OR ";
//            }
//        }
//        if (query1 != "" && courseId > 0) {
//            query1 = query1.substring(0, query1.length() - 4);
//
//            List<?> listNA = entityManager.createNativeQuery(query + query1).getResultList();
//
//            if (listNA != null) {
//                listNA.stream().forEach(p ->
//                        {
//                            Object[] item = (Object[]) p;
//                            PersonnelDTO.InfoForStudent tmp = (PersonnelDTO.InfoForStudent) result.stream().filter(c -> c.getPersonnelNo() != null && c.getPersonnelNo().equals(item[0].toString())).toArray()[0];
//                            tmp.setIsInNA(item[1] == null ? null : Boolean.parseBoolean(item[1].toString()));
//                            tmp.setScoreState(item[2] == null ? null : Long.parseLong(item[2].toString()));
//                        }
//                );
//            }
//        }
//        return result;
//    }

}
