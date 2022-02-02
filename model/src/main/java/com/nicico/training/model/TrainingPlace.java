package com.nicico.training.model;

import com.nicico.training.model.enums.EArrangementType;
import com.nicico.training.model.enums.EPlaceType;
import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_training_place")
public class TrainingPlace extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "training_place_seq")
    @SequenceGenerator(name = "training_place_seq", sequenceName = "seq_training_place_id", allocationSize = 1)
    @Column(name = "id")
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "c_capacity")
    private String capacity;

    @Column(name = "e_place_type", insertable = false, updatable = false)
    private EPlaceType ePlaceType;

    @Column(name = "e_place_type")
    private Integer eplaceTypeId;

    @Column(name = "e_arrangement_type", insertable = false, updatable = false)
    private EArrangementType eArrangementType;

    @Column(name = "e_arrangement_type")
    private Integer earrangementTypeId;

    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
    @JoinTable(name = "tbl_training_place_equipment",
            joinColumns = {@JoinColumn(name = "f_training_place_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_equipment_id", referencedColumnName = "id")})
    private Set<Equipment> equipmentSet;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_institute", insertable = false, updatable = false)
    private Institute institute;

    @Column(name = "f_institute")
    private Long instituteId;

    @Column(name = "c_description", length = 500)
    private String description;

    @OneToMany(mappedBy = "trainingPlace", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
    private Set<Alarm> alarms;
}