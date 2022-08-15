package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PersonnelStatisticInfoDTO;
import com.nicico.training.dto.ViewActivePersonnelDTO;
import com.nicico.training.iservice.ISynonymPersonnelService;
import com.nicico.training.model.SynonymPersonnel;
import com.nicico.training.repository.SynonymPersonnelDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SynonymPersonnelService implements ISynonymPersonnelService {
    private final SynonymPersonnelDAO dao;
    private final ModelMapper modelMapper;


    @Transactional(readOnly = true)
    public TotalResponse<PersonnelDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(dao, request, SynonymPersonnel -> modelMapper.map(SynonymPersonnel, PersonnelDTO.Info.class));
    }

    @Override
    public PersonnelStatisticInfoDTO searchStatistic(NICICOCriteria nicicoCriteria) {
        List<Object> complexList=new ArrayList<>(); List<Object> assistanceList=new ArrayList<>();
        List<Object> affairList=new ArrayList<>();List<Object> sectionList=new ArrayList<>();
        List<Object> unitList=new ArrayList<>();List<Object> statusList=new ArrayList<>();
       List<Map<String,String>> objects= (List<Map<String,String>>) nicicoCriteria.getCriteria();
      SearchDTO.SearchRq searchRq= SearchUtil.createSearchRq(nicicoCriteria);
    SearchDTO.CriteriaRq criteriaRq= searchRq.getCriteria();
    List<SearchDTO.CriteriaRq> criteriaRqs=  criteriaRq.getCriteria();
        for (int i = 0; i <criteriaRqs.size() ; i++) {

            if (criteriaRqs.get(i).getFieldName().equals("complexTitle")) {
                complexList = criteriaRqs.get(i).getValue();
            } else if (criteriaRqs.get(i).getFieldName().equals("ccpAssistant")) {
                 assistanceList=criteriaRqs.get(i).getValue();
            }else if(criteriaRqs.get(i).getFieldName().equals("ccpAffairs")){
                affairList=criteriaRqs.get(i).getValue();
            }else if(criteriaRqs.get(i).getFieldName().equals("ccpSection")){
                sectionList=criteriaRqs.get(i).getValue();
            }else if(criteriaRqs.get(i).getFieldName().equals("ccpUnit")){
                unitList=criteriaRqs.get(i).getValue();
            }else if(criteriaRqs.get(i).getFieldName().equals("empStatus")){
              List<Object> empList=  criteriaRqs.get(i).getValue();
            empList.stream().forEach(status->{
                    if(status.equals("1")){
                        status="اشتغال";
                        statusList.add(status);
                    }

                    if(status.equals("2")){
                        status=  "بازنشسته";
                        statusList.add(status);
                        status="بازنشسته&-پیش از موعد";
                        statusList.add(status);
                    }


                });
            }
        }

     List<Object> statistics=   dao.getStatisticInfoFromPersonnel(complexList,assistanceList,affairList,sectionList,unitList,statusList,complexList.size(),assistanceList.size(),affairList.size(),sectionList.size(),unitList.size(),statusList.size());
       return null;
    }

    @Override
    public SynonymPersonnel getByNationalCode(String nationalCode) {
        return dao.findSynonymPersonnelDataByNationalCode(nationalCode);
    }

    @Override
    public SynonymPersonnel getById(Long id) {
        Optional<SynonymPersonnel> optionalSynonymPersonnel=dao.findById(id);
        if (optionalSynonymPersonnel.isPresent())
        return dao.findById(id).get();
        else return null;
    }

    @Override
    public SynonymPersonnel getByPersonnelNo2(String personnelNo2) {
        return dao.findSynonymPersonnelDataByPersonnelNo2(personnelNo2);
    }

    @Transactional
    public ViewActivePersonnelDTO.PersonalityInfo getByPersonnelCode(String personnelCode) {
        Optional<SynonymPersonnel> optPersonnel = dao.findByPersonnelNoAndDeleted(personnelCode,0);
        final SynonymPersonnel personnel = optPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(personnel, ViewActivePersonnelDTO.PersonalityInfo.class);
    }

    @Override
    public Optional<SynonymPersonnel> getByPostCode(String postCode) {
        return dao.findFirstByPostCode(postCode);
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
