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
         "   select  case when :complexFlag= 0  then null else view_synonym_personnel.complex_title end  as complex ,\n" +
         " case when :assistanceFlag= 0 then null else view_synonym_personnel.ccp_assistant end  as assistant ,\n" +
         "    case when   :affairFlag= 0 then null else view_synonym_personnel.ccp_affairs end as affair,\n" +
         "  case when   :sectionFlag= 0  then null else view_synonym_personnel.ccp_section end as sec,\n" +
         "   case when   :unitFlag= 0 then null else view_synonym_personnel.ccp_unit end as unit ,\n" +
         "   case when :statusFlag= 0 then null else view_synonym_personnel.employment_status_title end as status,\n" +
         " \n" +
         "     COUNT(*) as total_count,\n" +
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
         "   and  (:complexFlag= 0 or  view_synonym_personnel.complex_title IN (:complex)) \n" +
         "    and (:assistanceFlag= 0 or  view_synonym_personnel.ccp_assistant IN (:assistance ))\n" +
         "    and (:affairFlag= 0 or  view_synonym_personnel.ccp_affairs IN (:affair))\n" +
         "    and (:sectionFlag= 0 or  view_synonym_personnel.ccp_section IN (:section ))\n" +
         "    and (:unitFlag= 0 or  view_synonym_personnel.ccp_unit IN (:unit ))\n" +
         "    and (:statusFlag= 0 or  view_synonym_personnel.employment_status_title IN (:status))\n" +
         "    \n" +
         "    \n" +
         "    group by \n" +
         "  case when   :complexFlag= 0 then null  else view_synonym_personnel.complex_title end ,\n" +
         " case when   :assistanceFlag= 0 then null else view_synonym_personnel.ccp_assistant end,\n" +
         "  case when    :affairFlag= 0 then null else  view_synonym_personnel.ccp_affairs end,\n" +
         "    case when :sectionFlag= 0 then null else view_synonym_personnel.ccp_section end,\n" +
         "   case when  :unitFlag= 0 then null else view_synonym_personnel.ccp_unit end,\n" +
         "   case when  :statusFlag= 0 then null else  view_synonym_personnel.employment_status_title end\n" +
         "   "

      ,nativeQuery = true)
    List<Object> getStatisticInfoFromPersonnel(List<String> complex, List<Object> assistance,List<Object> affair, List<Object> section ,
                                               List<Object>  unit , List<Object>  status,int complexFlag,
                                               int assistanceFlag,int affairFlag,int sectionFlag,
                                              int unitFlag,int statusFlag);


}