package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EvaluationAnswerDTO;
import com.nicico.training.iservice.IEvaluationAnswerService;
import com.nicico.training.model.EvaluationAnswer;
import com.nicico.training.model.EvaluationAnswerAudit;
import com.nicico.training.repository.EvaluationAnswerAuditDAO;
import com.nicico.training.repository.EvaluationAnswerDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EvaluationAnswerService implements IEvaluationAnswerService {

    private final ModelMapper modelMapper;
    private final EvaluationAnswerDAO evaluationAnswerDAO;
    private final EvaluationAnswerAuditDAO evaluationAnswerAuditDAO;

    @Transactional(readOnly = true)
    @Override
    public EvaluationAnswerDTO.Info get(Long id) {
        final Optional<EvaluationAnswer> sById = evaluationAnswerDAO.findById(id);
        final EvaluationAnswer evaluationAnswer = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EvaluationAnswerNotFound));
        return modelMapper.map(evaluationAnswer, EvaluationAnswerDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<EvaluationAnswerDTO.Info> list() {
        final List<EvaluationAnswer> sAll = evaluationAnswerDAO.findAll();
        return modelMapper.map(sAll, new TypeToken<List<EvaluationAnswerDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public EvaluationAnswerDTO.Info create(EvaluationAnswerDTO.Create request) {
        final EvaluationAnswer evaluationAnswer = modelMapper.map(request, EvaluationAnswer.class);
        return save(evaluationAnswer);
    }

    @Transactional
    @Override
    public EvaluationAnswerDTO.Info update(Long id, EvaluationAnswerDTO.Update request) {
        final Optional<EvaluationAnswer> sById = evaluationAnswerDAO.findById(id);
        final EvaluationAnswer evaluationAnswer = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EvaluationAnswerNotFound));
        EvaluationAnswer updating = new EvaluationAnswer();
        modelMapper.map(evaluationAnswer, updating);
        modelMapper.map(request, updating);

        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        evaluationAnswerDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(EvaluationAnswerDTO.Delete request) {
        final List<EvaluationAnswer> sAllById = evaluationAnswerDAO.findAllById(request.getIds());
        evaluationAnswerDAO.deleteAll(sAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EvaluationAnswerDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(evaluationAnswerDAO, request, evaluationAnswer -> modelMapper.map(evaluationAnswer, EvaluationAnswerDTO.Info.class));
    }

    @Override
    public List<EvaluationAnswer> getAllByEvaluationId(long id) {
        return evaluationAnswerDAO.findByEvaluationId(id);
    }

    @Override
    public List<EvaluationAnswerAudit> getAuditData(Long evaluationId) {
        return evaluationAnswerAuditDAO.getAuditData(evaluationId);
    }

    // ------------------------------

    private EvaluationAnswerDTO.Info save(EvaluationAnswer evaluationAnswer) {
        final EvaluationAnswer saved = evaluationAnswerDAO.saveAndFlush(evaluationAnswer);
        return modelMapper.map(saved, EvaluationAnswerDTO.Info.class);
    }


//    @Override
//    public List<EvaluationAnswerDTO.EvaluationIndexByField> getEvaluationIndexByField(List<Long> evaluationAreaIds, List<String> classCodes) {
//        List<?> teacherEvaluation = evaluationAnswerDAO.getEvaluationIndexByField(
//                evaluationAreaIds,
//                evaluationAreaIds == null ? 1 : 0,
//                classCodes,
//                classCodes == null ? 1 : 0
//        );
//
//        List<EvaluationAnswerDTO.EvaluationIndexByField> result = new ArrayList<>();
//        for (Object o : teacherEvaluation) {
//            Object[] fields = (Object[]) o;
//
//            EvaluationAnswerDTO.EvaluationIndexByField dto = new EvaluationAnswerDTO.EvaluationIndexByField();
//
//            dto.setCourseCode(fields[0] != null ? fields[0].toString() : null);
//            dto.setClassCode(fields[1] != null ? fields[1].toString() : null);
//            dto.setTeacherFirstName(fields[2] != null ? fields[2].toString() : null);
//            dto.setTeacherLastName(fields[3] != null ? fields[3].toString() : null);
//            dto.setTeacherNationalCode(fields[4] != null ? fields[4].toString() : null);
//            dto.setEvaluationAffairs(fields[5] != null ? fields[5].toString() : null);
//            dto.setPostTitle(fields[6] != null ? fields[6].toString() : null);
//            dto.setPostCode(fields[7] != null ? fields[7].toString() : null);
//            dto.setPersonnelNo2(fields[8] != null ? fields[8].toString() : null);
//            dto.setStudentAcceptanceStatus(fields[9] != null ? fields[9].toString() : null);
//            dto.setScore(fields[10] != null ? fields[10].toString() : null);
//            dto.setEvaluationId(fields[11] != null ? (BigDecimal) fields[11] : null);
//            dto.setEvaluationAverage(fields[12] != null ? (BigDecimal) fields[12] : null);
//            dto.setEvaluationField(fields[13] != null ? fields[13].toString() : null);
//
//            result.add(dto);
//        }
//
//        return result;
//    }

}
