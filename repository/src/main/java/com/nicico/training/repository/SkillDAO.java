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

    @Query(value = "SELECT * FROM tbl_skill ts where Not Exists(select * from TBL_COMPETENCE_SKILL tcs where ts.id=tcs.F_SKILL_ID) and " +
            " Not Exists(select * from TBL_SKILL_COURSE tsc where ts.id=tsc.F_SKILL_ID) and id=:skillId", nativeQuery = true)
    Skill getSkillUsedInOther(Long skillId);

    List<Skill> findByCourseIsNull();

    List<Skill> findByCourseMainObjectiveId(Long id);

    List<Skill> findSkillsByCourseMainObjectiveId(Long courseId);

    Skill findByTitleFaAndCategoryIdAndSubCategoryIdAndSkillLevelId(String TitleFa,Long CategoryId,Long SubCategoryId,Long SkillLevelId);
}
