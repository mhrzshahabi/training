package com.nicico.training.repository;

import com.nicico.training.model.Skill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SkillDAO extends JpaRepository<Skill, Long>, JpaSpecificationExecutor<Skill> {

    @Query(value = "select  nvl(LPAD(CAST(SUBSTR(max(s.c_code),5) AS integer) + 1, 3 , 0),'001') AS skillCode  from tbl_skill s  where s.c_code like :skillCodeStart%", nativeQuery = true)
    String findMaxSkillCode(String skillCodeStart);


    List<Skill> findByCourseIsNull();

    List<Skill> findByCourseMainObjectiveId(Long id);

    List<Skill> findSkillsByCourseMainObjectiveId(Long courseId);

    Skill findByTitleFaAndCategoryIdAndSubCategoryIdAndSkillLevelId(String TitleFa,Long CategoryId,Long SubCategoryId,Long SkillLevelId);
}
