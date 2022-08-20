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
import org.apache.poi.ss.formula.functions.T;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SynonymPersonnelService implements ISynonymPersonnelService {
    private final SynonymPersonnelDAO dao;
    private final ModelMapper modelMapper;
    @Autowired
    protected EntityManager entityManager;

    @Transactional(readOnly = true)
    public TotalResponse<PersonnelDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(dao, request, SynonymPersonnel -> modelMapper.map(SynonymPersonnel, PersonnelDTO.Info.class));
    }

    @Override
    @Transactional(readOnly = true)
    public SearchDTO.SearchRs searchStatistic(SearchDTO.CriteriaRq criteriaRq) {
       int complexFlag=0;int assistanceFlag=0;int affairFlag=0;int sectionFlag=0; int unitFlag=0; int statusFlag=0;
        List<Object> complexList=new ArrayList<>(); List<Object> assistanceList=new ArrayList<>();
        List<Object> affairList=new ArrayList<>();List<Object> sectionList=new ArrayList<>();
        List<Object> unitList=new ArrayList<>();List<Object> statusList=new ArrayList<>();
    List<SearchDTO.CriteriaRq> criteriaRqs=  criteriaRq.getCriteria();
        for (int i = 0; i <criteriaRqs.size() ; i++) {

            if (criteriaRqs.get(i).getFieldName().equals("complexTitle")) {
                complexList = criteriaRqs.get(i).getValue();
                if(complexList.size()>0) {
                    complexFlag = 1;
                }

            } else if (criteriaRqs.get(i).getFieldName().equals("ccpAssistant")) {
                 assistanceList=criteriaRqs.get(i).getValue();
                 if(assistanceList.size()>0) {
                    assistanceFlag =1;
                }
            }else if(criteriaRqs.get(i).getFieldName().equals("ccpAffairs")){
                affairList=criteriaRqs.get(i).getValue();
                if(affairList.size()>0) {
                   affairFlag= 1;
                }
            }else if(criteriaRqs.get(i).getFieldName().equals("ccpSection")){
                sectionList=criteriaRqs.get(i).getValue();
                if(sectionList.size()>0) {
                    sectionFlag= 1;
                }
            }else if(criteriaRqs.get(i).getFieldName().equals("ccpUnit")){
                unitList=criteriaRqs.get(i).getValue();
                if(unitList.size()>0) {
                    unitFlag= 1;
                }
            }else if(criteriaRqs.get(i).getFieldName().equals("empStatus")){
               List<Object> empList=  criteriaRqs.get(i).getValue();
                if(empList.size()>0) {
                    statusFlag= 1;
                }
            empList.stream().forEach(status->{
                if ("1".equals(status)) {
                    status = "اشتغال";
                    statusList.add(status);
                } if("2".equals(status)){
                    status= "بازنشسته";
                    statusList.add(status);
                } if("3".equals(status)){
                    status="بازنشسته&-پیش از موعد";
                    statusList.add(status);
                } if("4".equals(status)){
                    status="از کار افتاده ناشی از کار";
                    statusList.add(status);
                }if("5".equals(status)){
                    status="از کار افتاده غیر ناشی از کار";
                    statusList.add(status);
                } if ("6".equals(status)){
                    status="انفصال دایم";
                    statusList.add(status);
                } if("7".equals(status)){
                    status="خاتمه قرارداد";
                    statusList.add(status);
                }if("8".equals(status)){
                    status="اخراج";
                    statusList.add(status);
                } if("9".equals(status)){
                    status= "فوت";
                    statusList.add(status);
                } if("10".equals(status)){
                    status="فوت ناشی از کار";
                    statusList.add(status);
                } if("11".equals(status)){
                    status="فوت غیر ناشی از کار";
                    statusList.add(status);
                }
            });
            }
        }
        List<PersonnelStatisticInfoDTO> dtos=new ArrayList<>();
        Object[] oracleResult_Obj = null;
        List<?> results= makeNativeQueryOracle(complexList,assistanceList,affairList,sectionList,unitList,statusList,complexFlag,assistanceFlag,affairFlag,sectionFlag,unitFlag,statusFlag);
        if(results.size()>0){
            for (int i = 0; i < results.size() ; i++) {
                PersonnelStatisticInfoDTO dto=new PersonnelStatisticInfoDTO();
                oracleResult_Obj = (Object[]) results.get(i);
                dto.setComplexTitle(oracleResult_Obj[0] != null ? oracleResult_Obj[0].toString() : "");
                dto.setAssistance(oracleResult_Obj[1] != null ? oracleResult_Obj[1].toString() : "");
                dto.setAffairs(oracleResult_Obj[2] != null ? oracleResult_Obj[2].toString() : "");
                dto.setSection(oracleResult_Obj[3] != null ? oracleResult_Obj[3].toString() : "");
                dto.setUnit(oracleResult_Obj[4] != null? oracleResult_Obj[4].toString() : "");
                dto.setEmpStatus(oracleResult_Obj[5] != null ? oracleResult_Obj[5].toString() : "");
                dto.setTotalNumber(oracleResult_Obj[6] !=null ? oracleResult_Obj[6].toString() : "");
                dto.setManagerNumber(oracleResult_Obj[7] !=null ? oracleResult_Obj[7].toString() : "");
                dto.setBossNumber(oracleResult_Obj[8] != null ? oracleResult_Obj[8].toString(): "");
                dto.setAssistantNumber(oracleResult_Obj[9]!= null ? oracleResult_Obj[9].toString() : "");
                dto.setSupervisorNumber(oracleResult_Obj[10]!= null ? oracleResult_Obj[10].toString() : "");
                dto.setExpertsNumber(oracleResult_Obj[11]!= null ? oracleResult_Obj[11].toString() : "");
                dto.setAttendantsNumber(oracleResult_Obj[12]!= null ? oracleResult_Obj[12].toString() : "");
                dto.setWorkersNumber(oracleResult_Obj[13]!= null ? oracleResult_Obj[13].toString() : "");
                dto.setUnrankedNumber(oracleResult_Obj[14]!= null ? oracleResult_Obj[14].toString() : "");
                dtos.add(dto);
            }


        }
        SearchDTO.SearchRs<PersonnelStatisticInfoDTO> searchRs=new SearchDTO.SearchRs<>();
        searchRs.setList(dtos);
        searchRs.setTotalCount(dtos.stream().count());
       return searchRs;
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
   private List<?>  makeNativeQueryOracle(List <Object> complexList,List<Object> assistanceList,List<Object> affairList,List<Object> sectionList,List<Object> unitList,List<Object> statusList,int complexFlag,int assistanceFlag,int affairFlag,int sectionFlag,int unitFlag,int statusFlag){
     String   complexStrings = "";
     String  assistanceStrings="";
     String affairStrings="";
     String sectionStrings="";
     String  untiStrings="";
     String statusStrings="";
     if(complexList.size()>0){
         for (int i = 0; complexList.size()>i ; i++) {
             if(!complexStrings.equals("")){
                 complexStrings+=","+ "'"+complexList.get(i).toString()+"'";
             }else{
                 complexStrings+="'"+complexList.get(i).toString()+"'";
             }
         }
     }else{
         complexStrings="null";
     }
       if(assistanceList.size()>0){
           for (int i = 0; assistanceList.size()>i ; i++) {
               if(!assistanceStrings.equals("")){
                   assistanceStrings+=","+ "'"+assistanceList.get(i).toString()+"'";
               }else{
                   assistanceStrings+="'"+assistanceList.get(i).toString()+"'";
               }
           }
       }else{
           assistanceStrings="null";
       }
       if(affairList.size()>0){
           for (int i = 0; affairList.size()>i ; i++) {
               if(!affairStrings.equals("")){
                  affairStrings+=","+ "'"+affairList.get(i).toString()+"'";
               }else{
                   affairStrings+="'"+affairList.get(i).toString()+"'";
               }
           }
       }else{
           affairStrings="null";
       }
       if(sectionList.size()>0){
           for (int i = 0; sectionList.size()>i ; i++) {
               if(!sectionStrings.equals("")){
                  sectionStrings+=","+"'"+ sectionList.get(i).toString()+"'";
               }else{
                   sectionStrings+="'"+sectionList.get(i).toString()+"'";
               }
           }
       }else{
           sectionStrings="null";
       }
       if(unitList.size()>0){
           for (int i = 0; unitList.size()>i ; i++) {
               if(!untiStrings.equals("")){
                   untiStrings+=","+"'"+ unitList.get(i).toString()+"'";
               }else{
                  untiStrings+="'"+assistanceList.get(i).toString()+"'";
               }
           }
       }else{
           untiStrings="null";
       }
       if(statusList.size()>0){
           for (int i = 0; statusList.size()>i ; i++) {
               if(!statusStrings.equals("")){
                   statusStrings+=","+ "'"+statusList.get(i).toString()+"'";
               }else{
                  statusStrings+="'"+statusList.get(i).toString()+"'";
               }
           }
       }else{
           statusStrings="null";
       }



       String query= "select case when " + complexFlag + "= 0 then null else view_synonym_personnel.complex_title end  as complex  ,\n"+
              " case when " + assistanceFlag + "= 0 then null else view_synonym_personnel.ccp_assistant end as assistance  ,\n"+
              " case when "+ affairFlag + "= 0 then null else view_synonym_personnel.ccp_affairs end  as affair,\n"+
              " case when "+ sectionFlag + "= 0  then null else view_synonym_personnel.ccp_section end  as section,\n"+
              " case when "+ unitFlag + "= 0 then null else view_synonym_personnel.ccp_unit end  as unit,\n"+
              " case when "+ statusFlag + "= 0 then null else view_synonym_personnel.employment_status_title end as status ,\n"+
              " COUNT(*) as total_count,\n" +
              "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'مدیر' THEN 1 END) as manager_count ,\n" +
              "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'رئیس' THEN 1 END)as boss_count,\n" +
              "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'معاون مدیرعامل' THEN 1  END) as assiatant_count ,\n" +
              "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'سرپرست و کارشناس ارشد' THEN 1  END) as supervisor_count ,\n" +
              "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'مسئول و کارشناس' THEN 1  END) as expert_count ,\n" +
              "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'متصدی و تکنسین' THEN 1  END) as attendent_count ,\n" +
              "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'اجرایی' THEN 1  END)  as worker_count,\n" +
              "      SUM(CASE when view_synonym_personnel.post_grade_title is null THEN 1 else 0 END) as unranked_count \n" +
              "    FROM view_synonym_personnel \n" +
              " where 1=1\n"+
              "and  ("+complexFlag+"= 0 or  view_synonym_personnel.complex_title IN ("+complexStrings+"))\n "+
              "and ("+assistanceFlag+"=0 or  view_synonym_personnel.ccp_assistant IN ("+assistanceStrings+"))\n "+
              "and("+affairFlag+"= 0 or  view_synonym_personnel.ccp_affairs IN ("+affairStrings+")) \n"+
              "and ("+sectionFlag+"= 0 or  view_synonym_personnel.ccp_section IN ("+sectionStrings+"))\n"+
              "and ("+unitFlag+"= 0 or  view_synonym_personnel.ccp_unit IN ("+untiStrings+")) \n"+
              "and ("+statusFlag+"= 0 or  view_synonym_personnel.employment_status_title IN ("+statusStrings+")) \n"+
              "  group by \n"+
              "case when "+complexFlag+"= 0 then null  else view_synonym_personnel.complex_title end , \n"+
              "case when "+assistanceFlag+"= 0 then null else view_synonym_personnel.ccp_assistant end, \n"+
              "case when "+affairFlag+"= 0 then null else  view_synonym_personnel.ccp_affairs end, \n"+
              "case when "+sectionFlag+"= 0 then null else view_synonym_personnel.ccp_section end, \n"+
              "case when "+unitFlag+"= 0 then null else view_synonym_personnel.ccp_unit end, \n"+
              "case when "+statusFlag+"= 0 then null else  view_synonym_personnel.employment_status_title end";

       List<?> oracleResult = null;
      oracleResult = (List<?>) entityManager.createNativeQuery(query).getResultList();
      return  oracleResult;

   }


}
