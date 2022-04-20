package com.nicico.training.dto.teacherPdfRequirments;

import com.nicico.training.dto.*;
import com.nicico.training.dto.teacherPublications.ElsPublicationDTO;
import com.nicico.training.dto.teacherSpecialSkill.TeacherSpecialSkillDTO;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.academicBK.ElsAcademicBKFindAllRespDto;
import response.employmentHistory.ElsEmploymentHistoryFindAllRespDto;
import response.teachingHistory.ElsTeachingHistoryFindAllRespDto;

import java.util.List;
@Getter
@Setter
public class RequirementItemsResumeDTO extends BaseResponse {
    private ElsTeacherInfoDto.Resume infoDTO;
    private List<ElsAcademicBKFindAllRespDto> academicBKDTOs;
    private List<ElsTeachingHistoryFindAllRespDto.TeachingHistoryResume> teachingHistoryRespDTOs;
    private List<ElsPublicationDTO.Resume> publicationDTOS;
    private List<ElsEmploymentHistoryFindAllRespDto.Resume> executiveHistoryRespDTOs;
    private List<ElsTeacherCertificationDate> passedCourseRespDTOs;
    private List<ElsSuggestedCourse> suggestedCourseDTOs;
    private List<TeacherSpecialSkillDTO.Resume> specialSkillsInfos;
    private List<ElsPresentableResponse> presentableCourseDTOS;
    private List<ForeignLangKnowledgeDTO.Resume> foreignLangKnowledgeDTOS;

}
