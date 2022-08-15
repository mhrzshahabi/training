package com.nicico.training.repository;

import com.nicico.training.model.SynonymPersonnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SynonymPersonnelDAO extends JpaRepository<SynonymPersonnel, Long>, JpaSpecificationExecutor<SynonymPersonnel> {

    @Query(value = "select * from view_synonym_personnel where national_code = :nationalCode AND deleted = 0" , nativeQuery = true)
    SynonymPersonnel findSynonymPersonnelDataByNationalCode(String nationalCode);

    @Query(value = "select * from view_synonym_personnel where emp_no = :personnelNo2 AND deleted = 0" , nativeQuery = true)
    SynonymPersonnel findSynonymPersonnelDataByPersonnelNo2(String personnelNo2);

    Optional<SynonymPersonnel> findByPersonnelNoAndDeleted(String nationalCode, Integer deleted);

    Optional<SynonymPersonnel> findFirstByPostCode(String postCode);

    List<SynonymPersonnel> findAllByPersonnelNoOrderByIdDesc(String personnelNo);

 @Query(value ="    \n" +
         "   select  case when  view_synonym_personnel.complex_title is null  then null else view_synonym_personnel.complex_title end  as complex ,\n" +
         " case when  view_synonym_personnel.ccp_assistant is null then null else view_synonym_personnel.ccp_assistant end  as assistant ,\n" +
         "    case when    view_synonym_personnel.ccp_affairs is null then null else view_synonym_personnel.ccp_affairs end as affair,\n" +
         "  case when   view_synonym_personnel.ccp_section is null then null else view_synonym_personnel.ccp_section end as section,\n" +
         "   case when   view_synonym_personnel.ccp_unit is null then null else view_synonym_personnel.ccp_unit end as unit ,\n" +
         "   case when  view_synonym_personnel.employment_status_title is null then null else view_synonym_personnel.employment_status_title end as status,\n" +
         " \n" +
         "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'مدیر 'THEN 1 END) as manager_count,\n" +
         "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'رئیس' THEN 1 END) as boss_count,\n" +
         "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'معاون مدیرعامل' THEN 1 END) as assistant_count,\n" +
         "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'سرپرست و کارشناس ارشد' THEN 1 END) as supervisor_count,\n" +
         "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'مسئول و کارشناس' THEN 1 END) as expert_count,\n" +
         "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'متصدی و تکنسین' THEN 1 END) as attendant_count,\n" +
         "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN 'اجرایی' THEN 1 END) as worker_count,\n" +
         "     COUNT(CASE view_synonym_personnel.post_grade_title WHEN  null  THEN 1 END) as unranked_count\n" +
         "    from\n" +
         "\n" +
         "\n" +
         " view_synonym_personnel \n" +
         "\n" +
         "    \n" +
         "    \n" +
         " where 1=1\n" +
         "   and  ( :complexFlag = 0 or  view_synonym_personnel.complex_title IN (:complex)) \n" +
         "    and ( :assistanceFlag = 0 or view_synonym_personnel.ccp_assistant IN (:assistance ))\n" +
         "    and ( :affairFlag = 0 or view_synonym_personnel.ccp_affairs IN (:affair))\n" +
         "    and ( :sectionFlag = 0 or view_synonym_personnel.ccp_section IN (:section ))\n" +
         "    and ( :unitFlag = 0 or view_synonym_personnel.ccp_unit IN (:unit ))\n" +
         "    and ( :statusFlag = 0 or view_synonym_personnel.employment_status_title IN (:status))\n" +
         "    \n" +
         "    \n" +
         "    group by \n" +
         "  case when   view_synonym_personnel.complex_title is null then null else view_synonym_personnel.complex_title end ,\n" +
         " case when   view_synonym_personnel.ccp_assistant is null then null else view_synonym_personnel.ccp_assistant end,\n" +
         "  case when     view_synonym_personnel.ccp_affairs is null then null else  view_synonym_personnel.ccp_affairs end,\n" +
         "    case when  view_synonym_personnel.ccp_section is null then null else view_synonym_personnel.ccp_section end,\n" +
         "   case when   view_synonym_personnel.ccp_unit is null then null else view_synonym_personnel.ccp_unit end,\n" +
         "   case when   view_synonym_personnel.employment_status_title is null then null else  view_synonym_personnel.employment_status_title end\n" +
         "   "

      ,nativeQuery = true)
    List<Object> getStatisticInfoFromPersonnel(List<Object> complex, List<Object> assistance,List<Object> affair, List<Object> section ,
                                               List<Object>  unit , List<Object>  status,int complexFlag,
                                               int assistanceFlag,int affairFlag,int sectionFlag,
                                              int unitFlag,int statusFlag);

}