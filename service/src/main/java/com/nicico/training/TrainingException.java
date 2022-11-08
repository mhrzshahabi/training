package com.nicico.training;

import com.nicico.copper.common.IErrorCode;
import com.nicico.copper.common.NICICOException;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.util.prefs.NodeChangeEvent;

@Getter
public class TrainingException extends NICICOException {

    @Getter
    @Setter(AccessLevel.PRIVATE)
    private String msg;

    public TrainingException(IErrorCode errorCode) {
        super(errorCode);
    }

    // ------------------------------

    public TrainingException(ErrorType errorCode) {
        this(errorCode, null);
    }

    public TrainingException(ErrorType errorCode, String field) {
        super(errorCode, field);
    }

    public TrainingException(ErrorType errorCode, String field, String msg) {

        super(errorCode, field);
        setMsg(msg);
    }

    @Getter
    @RequiredArgsConstructor
    public enum ErrorType implements IErrorCode {

        NotFound(404),
        registerNotAccepted(406),
        QuestionBankNotFound(404),
        SkillLevelNotFound(404),
        SkillStandardNotFound(404),
        SkillStandardCategoryNotFound(404),
        SkillStandardSubCategoryNotFound(404),
        SyllabusNotFound(404),
        SkillStandardGroupNotFound(404),
        CourseNotFound(404),
        JobNotFound(404),
        TeacherNotFound(404),
        EquipmentNotFound(404),
        CategoryNotFound(404),
        SubCategoryNotFound(404),
        GoalNotFound(404),
        SkillNotFound(404),
        CompetenceNotFound(404),
        TclassNotFound(404),
        StudentNotFound(404),
        SkillGroupNotFound(404),
        JobCompetenceNotFound(404),
        InstituteNotFound(404),
        EducationLicenseNotFound(404),
        CityNotFound(404),
        StateNotFound(404),
        AddressNotFound(404),
        EducationOrientationNotFound(404),
        EducationMajorNotFound(404),
        EducationLevelNotFound(404),
        CountryNotFound(404),
        TrainingPlaceNotFound(404),
        AccountInfoNotFound(404),
        ContactInfoNotFound(404),
        PersonalInfoNotFound(404),
        CommitteeNotFound(404),
        TermNotFound(404),
        CheckListNotFound(404),
        BehavioralGoalNotFound(404),
        ClassCheckListNotFound(404),
        CheckListItemNotFound(404),
        CompanyNotFound(404),
        PostNotFound(404),
        NeedAssessmentNotFound(404),
        BankNotFound(404),
        BankBranchNotFound(404),
        NotEditable(404),
        DuplicateRecord(404),
        DuplicateMobile(404),
        NotDeletable(404),
        JobGroupNotFound(404),
        DCCNotFound(404),
        PostGroupNotFound(404),
        TrainingPostNotFound(404),
        OperationalUnitDuplicateRecord(406),
        PersonnelRegisteredNotFound(404),
        WrongPostalCode(404),
        ScoresNotFound(404),
        AttendanceNotFound(404),
        ParameterNotFound(404),
        QuestionnaireNotFound(404),
        Unknown(500),
        Unauthorized(401),
        Forbidden(403),
        RecordAlreadyExists(405),
        conflictAddress(406),
        conflict(409),
        conflictForManager(405),
        EquipmentExists(405),
        CompetenceTypeNotFound(404),
        NeedsAssessmentNotFound(404),
        NeedsAssessmentDomainNotFound(404),
        NeedsAssessmentPriorityNotFound(404),
        UpdatingInvalidOldVersion(400),
        EvaluationNotFound(404),
        EvaluationAnswerNotFound(404),
        EvaluationDeadline(406),
        ProvinceNotFound(404),
        InvalidData(405),
        PersonnelNotFound(404),
        NoChangeEvent(100),
        DepartmentNotFound(404),
        PostGradeNotFound(404),
        TestQuestionBadRequest(400),
        TestQuestionNotFound(404),
        SkillSubCatIsNotEqualWithNASubCat(408),
        SkillCatIsNotEqualWithNACat(411),
        NeedsAssessmentIsNotEditable(412),
        InvalidClassStatus(405),
        InvalidClassType(405),
        OperationalChartNotFound(404),
        OperationalChartHasChild(404),
        OperationalChartIsDuplicated(409);

        private final Integer httpStatusCode;

        @Override
        public String getName() {
            return name();
        }
    }
}
